Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbZJLOnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbZJLOnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbZJLOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:43:45 -0400
Received: from kroah.org ([198.145.64.141]:32846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321AbZJLOnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:43:45 -0400
Date: Mon, 12 Oct 2009 07:40:23 -0700
From: Greg KH <greg@kroah.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Haptic class support (v2)
Message-ID: <20091012144023.GB1239@kroah.com>
References: <20091006074533.GA28889@july>
 <20091011090549.GE1414@ucw.cz>
 <9c9fda240910111732x262a9510rf3dd862aa16d0bdf@mail.gmail.com>
 <5d5443650910120644x4180ff6bt45b72be86b50588f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650910120644x4180ff6bt45b72be86b50588f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 07:14:57PM +0530, Trilok Soni wrote:
> Hi Kyungmin,
> 
> On Mon, Oct 12, 2009 at 6:02 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> > On Sun, Oct 11, 2009 at 6:05 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >> On Tue 2009-10-06 16:45:33, Kyungmin Park wrote:
> >>> This patch includes two haptic devices, isa1000 and isa1200
> >>> ISA1000 is gpio based haptic, but isa1200 is based on I2C
> >>> Both are working on Samsung SoCs and tested.
> >>>
> >>> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
> >>> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
> >>> or
> >>> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot
> >>
> >> New device classes should certainly be documented in Documentation/.
> >>
> >> For example... is level 0-100?
> >
> > Basically. range from 0 to 255. also each device can set max level in
> > case of isa1000 it's 6.
> >
> >>  Is it valid to change level while 'oneshot' is running?
> >
> > we usually use it under 1 sec. but I think it's possible to change it
> > but not tried.
> >
> >>  Does oneshot use last level set?
> >
> > Right. it used last set value.
> >
> > If you don't mind to update these at Documentation please wait until
> > commit first patches merged.
> 
> Let's see what Greg prefers. Could you please refresh your patchset
> with probably addressing comments given in the isa1200 and samsung_pwm
> driver by me?

Greg wants to see patches that add sysfs files to the kernel, also
contain Documentation/ABI/ updates as well.

thanks,

greg k-h
