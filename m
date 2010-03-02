Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0CBUHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:07:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab0CBUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:07:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JqXIPwqRqoBqbe7LPjLqdxaYrp8fmMzr2A0xt9TBdziU/vskbSO4nfrYs4/t7jjjF4
         XygGR2OPusktet5D4yRHPaFB8HnYSXR0pf+kDqE0AmKFFnPSTx1qWHOA0H9EG0X4fiBh
         Tj0k4vFjNb4nCoHVuGYSAGGMM7GApVf5gsrgk=
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 14:07:16 -0600
Message-ID: <8db990a81003021207x1c9ed5fav2192f710ec363d06@mail.gmail.com>
Subject: 'sar' issue or core dump issue?
From: Lizhang Qin <lizhang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experience some performance issue for user space app, when
looking at 'sar' result, it showed things like below.

		          CPU     %user     %nice   %system   %iowait    %steal     %idle
	08:30:02          all      3.29      0.00      9.16      0.01
0.00     87.54
	08:30:12          all      0.38      0.00      2.40      0.38
0.00     96.84
	08:43:39          all      0.28      0.00      1.17      0.87
0.00     97.68

It shows all the records between 08:30:12 to 08:43:39 are missing.
Does it mean kernel actually lose all the statistic data during that
period?  How could that happen though?

I notice there is a big core dump file were written for a crash app
running in the machine.
Could a core dump interfere all the kernel scheduling on all cores (I
have 4 physical CPU adn 8 virtual cores).

Thanks.
