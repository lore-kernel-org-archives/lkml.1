Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYC0SwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYC0SwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYC0SwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:52:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:1641 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYC0SwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ex7jn9wx4Nx2OKl5A1iwidPcPfwDaUWIzT25MsVpkv+DVBW7iyqsmIlfuW/cv3ci/ZVxEnkHzXaBD3lJK9Rs4bf+clLDGx8CIrqBNJLACze1yKYuBb0GF6QPnCNif8vZU0xW7/NSJLVCySjO9IsiMXlJznJg7YPO9RAmuTcMaIM=
Message-ID: <3ae72650803271151k5a7b5c4cn5078b3bdf6a9c87a@mail.gmail.com>
Date: Thu, 27 Mar 2008 19:51:58 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Cc: "Greg KH" <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jens Axboe" <axboe@kernel.dk>, "Jeff Garzik" <jgarzik@pobox.com>,
       "Tejun Heo" <htejun@gmail.com>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <47E99A02.7040903@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>
	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>
X-Google-Sender-Auth: 26f83e266d0169a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 1:34 AM, Mark Lord <lkml@rtr.ca> wrote:
> Greg KH wrote:
>  > On Tue, Mar 25, 2008 at 01:37:03PM -0400, Mark Lord wrote:
>
> >> Perhaps Greg will chime in.
>  >
>  > I've been waiting to see if sanity will take hold of anyone here.
>  ..
>
>  So have we.  sysfs is a total nightmare to extract information from
>  under program / script control.  The idea presented in this thread,
>  is to have it cross-index the contents with a method that actually
>  makes it easy to access in many common scenarios, without requiring
>  huge gobs of code in user space.  Or in kernel space.
>
>  And it's not just a few 10s of lines of code currently,
>  but rather about 80-100 lines just to find the correct device subdir,
>  and *then* a few more 10s of lines of code to retrieve the value.

Hmm, 100 lines? What else do you need?

  $ grep -l 8:3 /sys/class/block/*/dev
  /sys/class/block/sdc/dev

Kay
