Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXHEMFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXHEMFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 08:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXHEMEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 08:04:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:35940 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbXHEMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 08:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TYnafrpRixiwVfqHwkzKlNcLwM9ltI49EQ5KkUCsoxKIsnwSeA1JCdQiZJgve4ZvovLzV+KQyhPgF6gLFdtodgu1bkGTh5Elr8VwtNxd4XAJ2StaLgEPABzTPuNqNxIZnMic+QerAh1vRX9NdQ2VAxL817ztqkF1wG+Xhi6A7GM=
Message-ID: <b6a2187b0708050504k78e053bdocc64a704d7f60145@mail.gmail.com>
Date: Sun, 5 Aug 2007 20:04:53 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
Cc: lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I thought that the X server did all that on its own these days, but that may
> be just the newer "intel" driver, not the older "i810" driver that you
> probably use.

I've just checked. Upon boot-up into text-console (even without
starting X), suspend-to-ram and resume will still corrupt the display.

> (Side note: if you have a modern distro, you might try to change the line
> that says
>         Driver "i810"

I've try changing to "intel" and both still doesn't restore the
text-console. "X" restored ok. On my Xorg build, i810_drv.so is linked
to intel_drv.so.

I tried to "revert" the commit, but it doesn't look like it can be
done easily as there're changes after the commit that affected those 2
files.

If there's anything I can help to debug, please let me know.

Thanks,
Jeff.
