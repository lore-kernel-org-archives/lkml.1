Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYI3SvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYI3SvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYI3SvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:51:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:25584 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYI3SvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mbjR3pLUKaU5VldgeUuJKYTnXXo+pnw8O1dOkWrpbHRxpOX/YMDKTkfy/HMujveP4a
         Q6UEBpijuhfOKBlDfdcD/jywLoNDu/BLzrCnJ9iY0qnU29/1Y/MFDNrViC1T3Z8Z+NDN
         fhqqF+yh3rop7hLlg485hZRcD/HCmtsw5/9dU=
Message-ID: <f4527be0809301151k66277093gd5303e73df6d834e@mail.gmail.com>
Date: Tue, 30 Sep 2008 19:51:00 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kernel.org missing .1 incremental patches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The incremental patches at
http://www.kernel.org/pub/linux/kernel/v2.6/incr/ seem to be missing
all .1 patches, for example there are patches to take 2.6.25 from
EXTRAVERSION = .2 to .17 but no patch for .0 > .1, attempting to apply
patch-2.6.25.1-2 to 2.6.25 will fail on the Makefile as it does not
have the correct starting version.

I assume the patches are generated from a script and there is a bug,
easily worked around by downloading the full 2.6.25.1 tarball but the
full incremental set would be very useful for a project I am working
on.

Thanks
Andy
