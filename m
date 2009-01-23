Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZAWOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZAWOJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZAWOJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:09:16 -0500
Received: from mx01.admin-box.com ([78.47.249.108]:38044 "EHLO
	mx01.admin-box.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZAWOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:09:15 -0500
Subject: Re: LED (leds_hp_disk) causes BUG: scheduling while atomic
From: Daniel Troeder <daniel@admin-box.com>
To: Pavel Machek <pavel@suse.cz>
Cc: deller@gmx.de, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090108114956.GB12120@elf.ucw.cz>
References: <1231156352.9735.6.camel@maya.local>
	 <20090106101415.GA13972@elf.ucw.cz> <1231401855.8422.15.camel@maya.local>
	 <20090108114956.GB12120@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 15:09:07 +0100
Message-Id: <1232719747.18163.96.camel@maya.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 08.01.2009, 12:49 +0100 schrieb Pavel Machek:
> On Thu 2009-01-08 09:04:15, Daniel Troeder wrote:
> > Am Dienstag, den 06.01.2009, 11:14 +0100 schrieb Pavel Machek:
> > > > I have a HP Compaq nc2400 notebook, and having recently installed 2.6.28
> > > > (gentoo patchset, self configured), I have observed the following:
> > > > 
> > > > When {I manually, udev automatically} load the leds_hp_disk module, my
> > > > disk-led flashes regularly _without_ disk activity. When I look at my
> > > > dmesg I see the following:
> > > 
> > > Yes, that's a (mis-feature).
> 
> What did does it flash, btw? It is red on hp2133 (while disk light is
> normally white).
It flashes orange, while normal HDD-activity-color is green.

(BTW: Problem persists in 2.6.28.1.)

Bye,
Daniel


