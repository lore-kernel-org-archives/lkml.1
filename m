Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZJFFHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZJFFHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZJFFHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:07:40 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:52018 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbZJFFHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HWFyZ9xX8VMteA/VDf9ZTq2Pv0UXr3xwFPRWwcrNMTGz7nv+7feDJ8AUxaM/Up9xo0
         lA1QwMQH8BSOmGOq9aNeAYkDEdi7FkZrvPqwi9v4sX9Z01Casy3gujUEjKiBjOLlVVrA
         rONGo5xucEoIY+KcTkdJOPcAsI/7HP6KdwMu8=
Date: Mon, 5 Oct 2009 22:06:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       List Linux Omap <linux-omap@vger.kernel.org>,
       Lauri Leukkunen <lauri.leukkunen@nokia.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] input: fix rx51 board keymap
Message-ID: <20091006050656.GI27881@core.coreip.homeip.net>
References: <1254317128-13954-1-git-send-email-amit.kucheria@verdurent.com> <20090930184843.GQ16865@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930184843.GQ16865@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:48:44AM -0700, Tony Lindgren wrote:
> * Amit Kucheria <amit.kucheria@verdurent.com> [090930 06:26]:
> > The original driver was written with the KEY() macro defined as (col, row)
> > instead of (row, col) as defined by the matrix keypad infrastructure. So the
> > keymap was defined accordingly.
> > 
> > Since the driver that was merged upstream uses the matrix keypad
> > infrastructure, modify the keymap accordingly.
> > 
> > While we are at it, fix the comments in twl4030.h and define PERSISTENT_KEY as
> > (r,c) instead of (c, r)
> > 
> > Tested on a RX51 (N900) device.
> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Lauri Leukkunen <lauri.leukkunen@nokia.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Dimitry, will you queue this one?
> 
> I'll also add it into omap-fixes-testing while waiting for it
> to go to mainline.
> 

Applied to the 'for-linus' branch.

-- 
Dmitry
