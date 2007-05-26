Return-Path: <linux-kernel-owner+w=401wt.eu-S1761917AbXEZSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761917AbXEZSlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXEZSlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:41:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:33748 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbXEZSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rV06HdYPHzfRVJGYm0hX8RVGX3+CUhsaE73cv2r8s94pa7C+P5f0IC8wqgxTWlqvy7Bu+PpUY3XAnlCYJ7+bg+Pi649ze1XYCPNz6RipNV3x6xqi0u5brrsK65TB5EkoM0/QFCuDjIXJNcAU3J/DrDu1lFFs1M+CpoMeQZWs+UM=
Message-ID: <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com>
Date: Sat, 26 May 2007 20:41:09 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200705261918.09469.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070524195616.234280@gmx.net> <200705261840.45896.mb@bu3sch.de>
	 <200705261904.04496.uwe.bugla@gmx.de>
	 <200705261918.09469.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> > Yes, sure! But the help text is very unlucky and humble, and it is not clear
> > enough in the sense of being distinctive enough, just clear and
> > comprehensive.
>
> Why don't you simply submit a patch to change the helptext then?

Is that ok ?

Discourage people from deselecting B44_PCI

Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>

--- kernel.orig/drivers/net/Kconfig	2007-05-26 20:38:02.000000000 +0200
+++ kernel/drivers/net/Kconfig	2007-05-26 20:38:15.000000000 +0200
@@ -1449,7 +1449,7 @@
 	help
 	  Support for b44 PCI devices.

-	  Say Y
+	  Unless you know what you are doing, say Y here.

 config FORCEDETH
 	tristate "nForce Ethernet support"
