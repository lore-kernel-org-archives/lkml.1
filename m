Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXHEMlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXHEMlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXHEMlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:41:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:64743 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXHEMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SbSxlCxsu7zNjNEHUqE5FwDeqy+7dtayeb/zdP9CDFE2ZBO1H6S119kipdTUZpL7E76BiGGq8jZJ8zGCTP7el2p+LVeqEDz7fQ3y+OzcJlFtNsHqOU5hA1spgT5F8lNihvoOMQn5VPFcljc2U+haqNnJwf36JD6YDoaNpZw/2PU=
Subject: Re: Linux 2.6.23-rc2
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 20:40:10 +0800
Message-Id: <1186317610.5220.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 20:11 +0800, Jeff Chua wrote:
> On 8/5/07, H. Peter Anvin <hpa@zytor.com> wrote:
> > Also, please submit your .config and kernel command line.
> 
> # cat /proc/cmdline
> 
> BOOT_IMAGE=(hd0,14)/linux/bzc1 root=/dev/sda2 resume=/dev/sda3 reboot=bios
> 
> 

Can you try with the boot option acpi_sleep=s3_bios,s3_mode

OR

if using s2ram, use s2ram -f a3

Tony

