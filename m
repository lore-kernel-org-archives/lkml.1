Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYDJTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYDJTP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYDJTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:15:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:2177 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYDJTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X/3HfrDn62LzOIq5dQVBkT2MRLX+p6vxAg279IYhP3YGo91lXaKKVF4FWkUTOT/82BOkXHUAbLzBNIaO1s0rqazoYxjb8CD69ALXMvYGg3ADCmEaG43YM5m2qZyeHMSJ0giq/UXXSyQaEpfFbvZMUL45ZEulKIBriwiuwE0es2Y=
Message-ID: <38b2ab8a0804101215t3ac692c3k2a2d955ca17eba9b@mail.gmail.com>
Date: Thu, 10 Apr 2008 21:15:15 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0804100804260.25651@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <Pine.LNX.4.61.0804100804260.25651@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 10, 2008 at 2:22 PM, linux-os (Dick Johnson)
<linux-os@analogic.com> wrote:
>
>  It becomes, as you say contentious, because with disk drives
>  manufactured during the past ten or so years, anything about
>  the physical geometry is fictitious. The PC BIOS continues to
>  calculate C/H/S because that's what BIOS interrupt 0x13 uses
>  to boot the machine. The boot code needs to know what the
>  BIOS claims or else it may fail to boot. However, once Linux
>  is up, there are no C/H/S unless they were invented --and
>  hopefully, the same as what the BIOS claims.
>

Some bootloaders want the partition starts to be aligned on a
cylinder size boundary. Try for example to setup a disk partition
table by using parted. It almost always complains about the
the size of the parts I try to create and suggest me others. The
same stands for sfdisk except that it just gives you some
warnings.

Thanks
-- 
Francis
