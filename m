Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXLTEcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXLTEcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXLTEcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:32:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:40517 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229AbXLTEcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:32:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S+KLACRj8pfRwsCZhoCZZWAOXYgIVYQbIdA3wC5Wsr25lJ3FbWOoBJqSsWEDxI1XdyJEQncgP5MhI6oipkuZXjzGJ5xkqvm8FdSssgN/PyeBooqr3+XreDYqS9AE4dIIKQx8x8DN4KvsvmSRxB3+TCE1EZgIfAC128OTfgCCIWs=
Message-ID: <a8e1da0712192032w5143f5cbs731a2f419812d2eb@mail.gmail.com>
Date: Thu, 20 Dec 2007 12:32:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: 2.6.24-rc5-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mdharm-usb@one-eyed-alien.net, gregkh@suse.de,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0712192226220.15674-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0712191643p74a88c35u45681b11b0492474@mail.gmail.com>
	 <Pine.LNX.4.44L0.0712192226220.15674-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 11:34 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Note carefully.  This:
>
> > > > 2. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> > > > disk it reports the part 2 and mount the partition as rw
>
> contradicts this:
>
> > > > 3. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> > > > disk it just mount the partition as ro with nothing more messages.

Oh, sorry. It's a typo. should be 2.6.24-rc5-mm1

>
> So which is correct?
>
> > Hi, Alan
> >
> > I'm sure about my post.
>
> But your post contradicts itself.  It can't be correct.
>
> > I'm not so famillar with usb.
> > It looks weird.  Seems that my device will be firstly recoganized as a
> > mp3 player and then a usb storage, so the system will report part 1 &
> > part 2 under previous  kernels.
>
> I think those "part 2" messages aren't caused by the kernel at all, but
> instead by some program running on your computer.  You could try
> booting into single-user mode and see if the behavior changes.

No doubt for me. Under osx plugin this device will popup a dialog(I
don't remember the content), after press ok then the disk icon go
away, and then being remount again.

>
> Also there's no question -- the device does behave strangely.  It
> shouldn't change the write-protect setting all by itself.

Yes, I think so too.
>
> Alan Stern
>
>
