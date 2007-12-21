Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbXLUH6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbXLUH6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXLUH6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:58:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:42721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXLUH6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rFciBn68GlvkTGvOJEvwYkquA6cBJPLQCHYjI9fJBf//m/l2qZqvl45CzzfWuXPXk/vyYKOWCUqAuprmMUJujRYhx/TYEIhTgRvhH45RqitKrTNFHImbYOqtgAuEdjcQ+gaNbDQn2sNwRK5/x/Fc9VXsCQb2u/rxdfHHOhyT6UM=
Message-ID: <a5ed8fe60712202358o7afc0bddhe77447d0d77631d8@mail.gmail.com>
Date: Fri, 21 Dec 2007 13:28:22 +0530
From: "Sourav Chakraborty" <sourav1877@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Increasing initial cwnd size
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are trying to test with kernel version 2.6.20,the RFC 3390
implementation of increased initial congestion window size(~4 when
MSS=1460 bytes).We are not getting consistent results
meaning,sometimes we see 4 data pkts sent without an ACK received and
sometimes we see 3.Also we would like to test by setting the initial
cwnd to a value more than 4.Can you guys advise us on how to do
that(where in the code should we change and what)?Also mention if
using linux 2.6.23 kernel instead of  the one we are using,would help
in this work.

Thanks and Regards
Sourav
