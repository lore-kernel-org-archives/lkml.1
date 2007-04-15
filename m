Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXDOXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXDOXIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXDOXIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:08:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:60148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbXDOXIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q2MVeqwCmyXg0ipnQZg8Xtu0qzvQjqZzZHKHx0JoP1ZSewPqZZk0nm+NhFRgbjgAG2ElLiFoCvs7+FkaOReSGKVsQyRxNnLffKiwxhwdxplOTZ+ZXs0RKlpuE+hItj0u/5WCEs+YwcDZgtyZy1IU6yAwKIJaFI2wuL0JGc5iuw0=
Subject: Re: [3/3] 2.6.21-rc6: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Marcus Better <marcus@better.se>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org
In-Reply-To: <200704151826.33837.marcus@better.se>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <20070414003808.GU5907@stusta.de> <1176515823.4807.7.camel@daplas>
	 <200704151826.33837.marcus@better.se>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 07:08:45 +0800
Message-Id: <1176678525.16909.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 18:26 +0200, Marcus Better wrote:
> Antonino A. Daplas wrote:
> > A screen with blinking green blocks implies that your display is in text
> > mode, not in graphics mode.
> 
> Yes, it happens when I suspend from text mode.

Just for clarification, do you suspend from VESA framebuffer console or
from VGA text console? If from the latter, that's actually worse from
the user's point of view, but I can modify vgacon so that it saves its
state on suspend and restore it on resume.


> > If the above does not work, also try
> >
> > acpi_sleep=s3_bios,s3_mode
> 
> Will try, but I'm using "s2ram -f -a3" which should mean precisely the above 
> IIUC.

Okay.

Tony


