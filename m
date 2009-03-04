Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZCDJA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZCDJA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZCDJAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:00:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:58365 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZCDJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qiWLZl6B0AbyR4L9iz2kiZG05zSSbod87bmi3PxBnP/WURCWHN4r1NPbs58UL/G3SF
         YrWpo8tTGwN7Qxrp9lvzjJUb1oeMJvcInLYPeFY5GOyUt+E/JCrbD0X4WFJkeNdPWcQ1
         puWEXbU8d+m+CfyNrdFwCYkZd7EjcKZnXJVPQ=
Date: Wed, 4 Mar 2009 01:00:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090304090026.GC7394@dtor-d630.eng.vmware.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090228141725.ZZRA012@mailhub.coreip.homeip.net> <20090301003014.GA22673@frodo> <20090228165156.ZZRA012@mailhub.coreip.homeip.net> <20090301144018.GA23581@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301144018.GA23581@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 04:40:19PM +0200, Felipe Balbi wrote:
> On Sat, Feb 28, 2009 at 04:58:01PM -0800, Dmitry Torokhov wrote:
> > On Sun, Mar 01, 2009 at 02:30:18AM +0200, Felipe Balbi wrote:
> > > On Sat, Feb 28, 2009 at 02:23:03PM -0800, Dmitry Torokhov wrote:
> > > > Hi Felipe,
> > > > 
> > > > On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> > > > > From: Felipe Balbi <felipe.balbi@nokia.com>
> > > > > 
> > > > > This is part of the twl4030 multifunction device driver.
> > > > > 
> > > > > With this driver we add support for reporting KEY_POWER
> > > > > events via the input layer.
> > > > 
> > > > ...
> > > 
> > > thanks for reviewing, how about the version below:
> > > 
> > 
> > Looks good, couple more items...
> 
> Fixed the extra comments and also got rid of the global input_dev
> structure. It could be fetched by passing it to request_irq() and
> platform_set/get_drvdata():
> 

Cool, I will keep it in my tree pending the threaded IRQ issue
resolution.

-- 
Dmitry
