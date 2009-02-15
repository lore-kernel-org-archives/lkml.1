Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZBONev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZBONev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 08:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZBONen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 08:34:43 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:35954 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBONem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 08:34:42 -0500
Date: Sun, 15 Feb 2009 14:34:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215143433.68241a34@hyperion.delvare>
In-Reply-To: <20090214142346.ZZRA012@mailhub.coreip.homeip.net>
References: <499569A9.5030202@suse.de>
	<20090214142346.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 14:25:56 -0800, Dmitry Torokhov wrote:
> On Fri, Feb 13, 2009 at 01:38:01PM +0100, Frank Seidel wrote:
> > -module_param_named(invert, hdaps_invert, bool, 0);
> > -MODULE_PARM_DESC(invert, "invert data along each axis");
> > +module_param_named(invert, hdaps_invert, int, 0);
> > +MODULE_PARM_DESC(invert, "invert data along each axis. 1 invert x-axis, "
> > +		 "2 invert y-axis, 3 invert both axes.");
> >  
> 
> Why don't you make these 0644? I don't see why they can't be changed
> "on fly".

hdaps_invert can already be read and written via a sysfs attribute. We
really don't need 2 ways to do it, so either the sysfs file or the
module parameter should be dropped.

-- 
Jean Delvare
