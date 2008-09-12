Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYILUee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYILUee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYILUe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:34:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40671 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYILUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=exwIkHB48FhURzRBWdqH6eMC1OaLRZzQziAiXaoU2XquWfAXFnoEIXyuRQI0Ultl67
         i7DOuehU1RPuKjqXKYZ00BGv4YsBNvmLlp5kEw2KKnfYxuHmJSDYMUtTjBcgStdBgvzi
         a6WNbsOKttRcHJ3Gf5s036bqwS7rdO43sdPwI=
Message-ID: <457e13650809121334p53b7f79bra12898d2681385c1@mail.gmail.com>
Date: Fri, 12 Sep 2008 23:34:24 +0300
From: "Oleksandr Natalenko" <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: scaling doesn't work after waking up (repeated)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After suspending to RAM scaling doesn't work for the second core of my
Pentium Dual-Core T2330.

Before suspending:
cpu MHz         : 800.000       #CPU0
cpu MHz         : 800.000       #CPU1

After suspending and waking up:
cpu MHz         : 800.000       #CPU0
cpu MHz         : 1596.079      #CPU1

I've observed it with kernel 2.6.25, 2.6.26, 2.6.27-rc6-git2.
It has not been fixed since my first bug report to LKML.

Processor ID:
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  T2330  @ 1.60GHz
stepping        : 13

Regards,
 post-factum
