Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYEOCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYEOCmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYEOCma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:42:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYEOCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:42:29 -0400
Date: Wed, 14 May 2008 19:41:41 -0700
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, dean@sensoray.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
Message-ID: <20080515024141.GB21941@kroah.com>
References: <20080514205927.GA13134@kroah.com> <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 03:17:42AM +0200, Markus Rechberger wrote:
> Hi Dean, Greg,

Adding dean to the cc: line...  :)
> 
> On 5/14/08, Greg KH <greg@kroah.com> wrote:
> > From: Dean Anderson <dean@sensoray.com>
> >

<big patch snipped>

> Why do you do those conversions in kernelspace?
> ffmpeg/libswscale has optimized code for colourspace conversions.
> I know a few drivers do that in kernelspace but it's way more flexible
> in userspace and depending on the optimization requires less CPU
> power.

I thought they were there as needed by some V4L1 applications, but that
code was recently removed by Dean I think.  If they don't need to be
there, and userspace apps can properly handle the different colorspace,
then I'll be glad to remove them.

thanks,

greg k-h
