Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZL3Rdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZL3Rdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZL3Rdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:33:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56570 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZL3Rdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=isYrr3wCvgrg1m7NwKYxqC8zhR/T/ZGtuY1CAt5SfviiR3UvHP1DaorDZpvo2DX8no
         raLcb4sCNq0hBAsQ6s69o/H9meaYQXAy/kyro4NVOx4CXTwTF2R6IqhECebPGMXB7YcX
         0m41ZJeC4A95k/QjhDnfxB4/l8qCSVQG9mw9I=
Date: Wed, 30 Dec 2009 18:33:37 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 00/14] USB: serial: fix DMA buffers on stack and
 endianess bugs
Message-ID: <20091230173337.GB15063@localhost>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <20091230160610.GB29476@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230160610.GB29476@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 06:06:11PM +0200, Dan Carpenter wrote:
> On Mon, Dec 28, 2009 at 11:01:44PM +0100, Johan Hovold wrote:
> > Hi, 
> > 
> > These patches should address all remaining instances of DMA buffers on stack
> > (being passed to usb_control_msg) for the usb serial drivers. They also fix a
> > few endianess bugs I found along the way and do some minor clean up.
> > 
> 
> Wow.  You have inspired me again to update smatch.  It didn't catch any of
> those.
> 
> Smatch found one other dma bug so I'll send a patch for it.  (I would feel like
> a jerk leaving it for you to fix on top of all the other stuff you have
> done.)

Good catch. I only backtracked from direct calls to usb_control_msg. :)
Doing so by hand can be quite tedious so automatic testing for this is
greatly appreciated.

Thanks,
Johan

