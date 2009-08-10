Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbZHJRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbZHJRdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZHJRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:33:55 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58128 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbZHJRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:33:54 -0400
Subject: Re: [PATCH] regulator: userspace: use sysfs_create_group
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: felipe.balbi@nokia.com
Cc: ext Mike Rapoport <mike@compulab.co.il>, Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090810060610.GN14802@nokia.com>
References: <1249840885-13498-1-git-send-email-me@felipebalbi.com>
	 <4A7FAE22.80809@compulab.co.il>  <20090810060610.GN14802@nokia.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 18:33:55 +0100
Message-Id: <1249925635.18340.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 09:06 +0300, Felipe Balbi wrote:
> On Mon, Aug 10, 2009 at 07:20:34AM +0200, ext Mike Rapoport wrote:
> > 
> > 
> > Felipe Balbi wrote:
> > > Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> > > ---
> > 
> > NAK
> > 
> > >  drivers/regulator/userspace-consumer.c |   44 ++++++++++++++++----------------
> > >  1 files changed, 22 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
> > > index 06d2fa9..a7e8e0b 100644
> > > --- a/drivers/regulator/userspace-consumer.c
> > > +++ b/drivers/regulator/userspace-consumer.c
> > > @@ -93,16 +93,20 @@ static ssize_t reg_set_state(struct device *dev, struct device_attribute *attr,
> > >  static DEVICE_ATTR(name, 0444, reg_show_name, NULL);
> > >  static DEVICE_ATTR(state, 0644, reg_show_state, reg_set_state);
> > >  
> > > -static struct device_attribute *attributes[] = {
> > > -	&dev_attr_name,
> > > -	&dev_attr_state,
> > > +static struct attribute *attributes[] = {
> > > +	&dev_attr_name.attr,
> > > +	&dev_attr_state.attr,
> > 
> > NULL?
> > Except that patch is Ok.
> 
> oops, sorry for that, here's updated version
> 
> ================================ CUT HERE =====================================
> 
> >From 5e3502b30b2cbd30946e1240d62905db33716dbd Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <felipe.balbi@nokia.com>
> Date: Mon, 10 Aug 2009 09:05:13 +0300
> Subject: [PATCH] regulator: userspace: use sysfs_create_group
> 
> and avoid introducing our own loops for creating
> several sysfs entries.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
>  drivers/regulator/userspace-consumer.c |   45 ++++++++++++++++---------------
>  1 files changed, 23 insertions(+), 22 deletions(-)
> 

New version applied.

Thanks

Liam

