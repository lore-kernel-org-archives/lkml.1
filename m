Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZDZWTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZDZWTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 18:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZDZWT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 18:19:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47686 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbZDZWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 18:19:26 -0400
Date: Sun, 26 Apr 2009 18:18:48 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 15/15] modpost: convert modpost to use HEAD_TEXT_SECTION
 macro.
In-Reply-To: <20090426113042.GN28642@uranus.ravnborg.org>
Message-ID: <alpine.DEB.2.00.0904261805080.28205@vinegar-pot.mit.edu>
References: <1240711870-30505-6-git-send-email-tabbott@mit.edu> <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu>
 <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu> <1240711870-30505-15-git-send-email-tabbott@mit.edu>
 <20090426113042.GN28642@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Sam Ravnborg wrote:
> I have seen linkers that added a number after the section names
> in certain situations. Often this is due to mix of sections
> with different flags ("ax" versus no "ax").
> This is the background for the wildcard.
> 
> With your patchset we should not see any such users - but we 
> should then warn if they showed up anyway if we do not silently
> support them.

Right, that is exactly the purpose of my
  [PATCH] modpost: Check the section flags, not name, to catch missing 
  "ax"/"aw"
  <http://lkml.org/lkml/2009/2/26/503>
which is also the second patch in this thread (as [PATCH v3 2/3]).

This patch also catches some possible bugs that the existing check misses, 
even without -ffunction-sections, so it would be nice to get it merged 
independently.

Anders
