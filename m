Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbYHECxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbYHECxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYHECwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:52:55 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2277 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYHECwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:52:54 -0400
Date: Tue, 5 Aug 2008 04:50:16 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Adrian Bunk <bunk@kernel.org>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Kconfig no longer outputs a .config with freshly updated defconfigs
In-Reply-To: <20080804210848.GA29902@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0808050435320.6791@localhost.localdomain>
References: <1217693013.2328.22.camel@localhost.localdomain>
 <20080802192646.GR19682@cs181140183.pp.htv.fi> <20080803080019.GA13265@uranus.ravnborg.org>
 <20080803100732.GA7442@cs181140183.pp.htv.fi> <20080804210848.GA29902@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 4 Aug 2008, Sam Ravnborg wrote:

> > Why can't we simply always write the .config?
> 
> Hi Adrian.
> 
> I just pushed a patch that does this.

If I see it correctly that's not quite correct either. The old 
silentoldconfig does a few things differently than a normal config target, 
because it's a special target called by Kbuild when needed:

- bail out if input is needed but stdio is not a tty
- silent mode
- update .config only as needed
- always update autoconf

With the change to make the silent mode the default, the "silent" name has 
become a little obsolete and should probably be renamed, but whatever the 
name above actions should still be done if called by Kbuild internally.

bye, Roman
