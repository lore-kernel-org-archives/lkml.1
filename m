Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYHMUcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYHMUcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYHMUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:31:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43379 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYHMUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:31:44 -0400
X-Sasl-enc: 0aleNiM3qIj55w/3QyRl9FqGLeKjhma68uD6r5Nt8kgY 1218659503
Date: Wed, 13 Aug 2008 17:31:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080813203137.GB27546@khazad-dum.debian.net>
References: <20080813080618.GA16061@elf.ucw.cz> <20080813152431.GD8232@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813152431.GD8232@mit.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 10:06:18AM +0200, Pavel Machek wrote:
> > While verifying that -rc2 regression is gone, I noticed alarming
> > stuff:
> > 
> > 1) thinkpad x60 relies on passive cooling. You have nice 1.8GHz cpu,
> > which goes away as soon as you load it.
> > 
> > 2) after some time it decides that 100% cpu in 1.0GHz is fine for you,
> > and it takes quite long to recover.
> 
> There is no fan in the X60?  I didn't think that was the case.  I do

It has a fan, yes.

> know the fans have a tendency to go bad within 12-18 months, and so
> the CPU heat sink and fan unit needs to be replaced perdiocially.
> What does /proc/acpi/ibm/fan report? 

ThinkPad fans have a overdesign range of about 2x, they almost never stop
because they're too old.  Clogged in dirt, on the other hand... a clogged
fan often spins FASTER and cools less.

Want to see how much your fan has as far as a safety margin goes? use
thinkpad-acpi to measure RPMs in level 7 and also when you switch PWM off
(i.e. set it to 100% duty cycle).  Mine gets faster by 1500RPM or so that
reflects the extra torque the EC can apply to get the fan to run at the
speed it wants it to.

But the thermal sink interface to the CPU and GPU are sometimes crap [when
compared with the quality of the rest of the machine].  Open it, remove the
crap, and replace it with a very high quality compound.  Dependin on
ThinkPad model, you also need to repair thermal sink design defects to make
it fit properly (read: press really tightly) on all chips.

> As mentioned previously on this list, Lenovo has had a relatively bad
> track record with fan failures and with incompetent installation of
> the heat sink with bad applications of the thermal compound; it's the
> one failings of an otherwise very nice laptop design.

Indeed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
