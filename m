Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYABRKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYABRKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYABRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:10:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYABRKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:10:41 -0500
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
From: Eric Paris <eparis@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Greg KH <greg@kroah.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712212358440.25803@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
	 <1198269079.3732.3.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
	 <20071221211602.GA14811@1wt.eu>
	 <Pine.LNX.4.64.0712212303410.18570@fbirervta.pbzchgretzou.qr>
	 <20071221223526.GC24780@kroah.com>
	 <Pine.LNX.4.64.0712212358440.25803@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 12:09:31 -0500
Message-Id: <1199293771.3716.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 23:59 +0100, Jan Engelhardt wrote:
> On Dec 21 2007 14:35, Greg KH wrote:
> >> >> >I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
> >> >> >base 10 as well
> >> >> 
> >> >> sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.
> >> >
> >> >yes but if you cat  /proc/sys/vm/mmap_min_addr, it returns in base 10.
> >> 
> >> sysfs should probably be tuned to output it in a preferred base.
> >
> >Again, this is sysctl, not sysfs.  two very different things...
> >
> Argh... :)  Just shows that /proc is the wrong place for system variables.
> 
> Well, module_params(integer) are autobase, and that's all I needed so 
> far :-D

So in the end we are all happy with the original patch I sent?

-Eric

