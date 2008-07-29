Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYG2MiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYG2MiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYG2MiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:38:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34779 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYG2MiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:38:07 -0400
Date: Tue, 29 Jul 2008 14:38:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Please pull sysdev attribute class hot fix
Message-ID: <20080729123801.GJ30344@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,

Please pull the following fix for a oops hitting some distributions
at boot. That was a fallout of the sysdev attribute class changes.
The scheduler attributes were declare wrong (as a normal attribute
instead of a class attribute) and this latent bug leads to crashes now.

Sending directly because lots of people seem to hit that.

BTW the distributions shouldn't use that at all at boot. It's really
a setting for some specialized server setups. SUSE event 
sets it to a value (2) that currently doesn't exist. But we have to fix 
it of course.

Thanks.

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git fix

Andi Kleen (1):
      Make scheduler sysfs attributes sysdev class attributes

 kernel/sched.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)
