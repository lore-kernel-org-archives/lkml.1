Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZL3QGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZL3QGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZL3QGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:06:31 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54592 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZL3QGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=OMXFoApPH2QZDbNZIhmY3wpHDtv9iW66uUoMuw2XsahBB7MXo1bqlh5KEQQyDXs/KY
         /AZFMGRY6AYnhrIy9vnKkIPCOq3CtaDp1EApLOBC0z9UxildZuywdE3gUzQ3WnwpnG6W
         PaUbs/jJYwwzHaeHRxutIf8FyKDYgzwmzg01M=
Date: Wed, 30 Dec 2009 18:06:11 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] USB: serial: fix DMA buffers on stack and
	endianess bugs
Message-ID: <20091230160610.GB29476@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Johan Hovold <jhovold@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 11:01:44PM +0100, Johan Hovold wrote:
> Hi, 
> 
> These patches should address all remaining instances of DMA buffers on stack
> (being passed to usb_control_msg) for the usb serial drivers. They also fix a
> few endianess bugs I found along the way and do some minor clean up.
> 

Wow.  You have inspired me again to update smatch.  It didn't catch any of
those.

Smatch found one other dma bug so I'll send a patch for it.  (I would feel like
a jerk leaving it for you to fix on top of all the other stuff you have
done.)

regards,
dan carpenter

