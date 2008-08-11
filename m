Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYHKNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYHKNtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYHKNtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:49:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYHKNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:48:59 -0400
Date: Mon, 11 Aug 2008 15:50:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jmerkey@wolfmountaingroup.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Keith Owens <kaos@ocs.com.au>, Jay Lan <jlan@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080811135004.GS9038@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808132953.GB3840@redhat.com> <20080808180303.GB9038@one.firstfloor.org> <20080811130256.GB28030@redhat.com> <43117.166.70.238.45.1218460302.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43117.166.70.238.45.1218460302.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 07:11:42AM -0600, jmerkey@wolfmountaingroup.com wrote:
> I found a problem with APIC NMI support which seems to affect all the
> debuggers, but appears machine specific -- at least I can reproduce it
> with all of the modules MDB, KDB, and KGDB modules on my ACER 2410 dual

A couple of laptop BIOS (e.g. some thinkpads) are unfortunately
not NMI safe. There is no known workaround other than not using NMIs
on these systems.

There's unfortunately no global blacklist for these systems, although
having would be useful for a couple of subsystems.

-Andi

