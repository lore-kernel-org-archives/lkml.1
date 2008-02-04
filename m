Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYBDLnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYBDLnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYBDLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:43:15 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:16397 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYBDLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S3rqR8BwADwLFkksKMo9/XcfsjkudIlZbzBLN1SCEBnrqH4OSXFjdndjqXQ3bJ0kHKWpxTOzIsDHOF0azJTbKo3CG3aH0XhdsvBx0EGjC9QpPInvggDi1IPlkml5QdegMnxKCRkmH3EMf0eZtkNal4oaUMtfcn6pz3tO2+CHBN8=
Message-ID: <e85b9d30802040343j13a0ec39if646740b0c26b7c6@mail.gmail.com>
Date: Mon, 4 Feb 2008 12:43:11 +0100
From: Matthew <jackdachef@gmail.com>
To: greg@kroah.com
Subject: [PATCH] USB: mark USB drivers as being GPL only
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

>Over two years ago, the Linux USB developers stated that they believed
>there was no way to create a USB kernel driver that was not under the
>GPL.  This patch moves the USB apis to enforce that decision.

>There are no known closed source USB drivers in the wild, so this patch
>should cause no problems.

hm, I'm not sure, but will your patch make Samsung's Unified Linux
Driver for printing & scanning stop working?
http://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?CDSite=DE&CttFileID=801111&CDCttType=DR&ModelType=N&ModelName=SCX-4521F&VPath=DR/200707/20070720165133984_UnifiedLinuxDriver.tar.gz

another Manufacturer / Candidate I'm worrying about is Brother:
http://solutions.brother.com/linux/en_us/index.html
Brother is providing opensource cups drivers (kudos to the developers
@ Brother for that!), the sane-drivers however seem to be closed
source, will those work ?

I'm no developer, just a heavy user ;) so unfortunately I can't tell
whether those drivers are dependent on being NOT GPL,
if your patch will find its inclusion into Linus' mainline-tree,
there's still the possibility to revert that patch, right ? (freedom
of doing with the code what I need to)

Many thanks in advance & thanks a lot for your work :)

Mat
