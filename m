Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZIKHUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZIKHUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZIKHUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:20:50 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50508 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZIKHUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:20:49 -0400
Date: Fri, 11 Sep 2009 09:20:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: RFC: Light sensors, unifying current options?
Message-ID: <20090911092049.70887ad0@hyperion.delvare>
In-Reply-To: <1252634101.3483.514.camel@rzhang-dt>
References: <4A9FC9D7.20000@cam.ac.uk>
	<1252308744.3483.414.camel@rzhang-dt>
	<4AA4F194.1070507@cam.ac.uk>
	<1252467684.3483.446.camel@rzhang-dt>
	<4AA79144.8060104@cam.ac.uk>
	<1252546449.3483.476.camel@rzhang-dt>
	<4AA8CF57.4010409@cam.ac.uk>
	<1252634101.3483.514.camel@rzhang-dt>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 09:55:01 +0800, Zhang Rui wrote:
> On Thu, 2009-09-10 at 18:05 +0800, Jonathan Cameron wrote:
> > Some sensors, e.g. tsl2561 use an internal clock to do sampling and hence
> > have some predefined period in which the reading taken doesn't change.
> > Perhaps exporting said period would be useful to userspace?
> > 
> I don't think so.
> IMO, the tsl2561 driver should handle this, and there is no need to
> annoy the user space.
> i.e. users always assume the content of "illuminance" attribute is
> valid, and it's the driver's job to make this true. We don't need to
> document this.

I agree with Rui on this. Let's not delegate everything to user-space,
otherwise it's pointless to write kernel drivers in the first place.

-- 
Jean Delvare
