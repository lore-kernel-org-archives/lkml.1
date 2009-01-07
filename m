Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZAGM1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZAGM1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZAGM1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:27:31 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38240 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZAGM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:27:30 -0500
Date: Wed, 7 Jan 2009 13:27:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at
	6b6b6b6b
Message-ID: <20090107122728.GB4633@osiris.boeblingen.de.ibm.com>
References: <4963F368.7080909@gmail.com> <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com> <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com> <20090107091534.GA4633@osiris.boeblingen.de.ibm.com> <1231319946.14720.7.camel@penberg-laptop> <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 07:36:57PM +0800, Jeff Chua wrote:
> On Wed, Jan 7, 2009 at 5:19 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > On Wed, 2009-01-07 at 10:15 +0100, Heiko Carstens wrote:
> >> I missed to convert disable_nonboot_cpus to
> >> stop_machine_create/destroy.
> >> So it's a use before-even-allocated bug.
> >> The patch below should hopefully fix it:
> >> Subject: [PATCH] cpu hotplug: add stop_machine_create/destroy to disable_nonboot_cpus
> > Looks good to me!
> 
> This also fixes the suspend-to-ram/disk problem. Without it, the
> system will just hang.
> 
> Thanks for the fix.

Did you also see the reboot problem and does the patch fix it for you?
