Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbYHEUv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbYHEUv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbYHEUvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:51:05 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:38658 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764197AbYHEUvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:51:02 -0400
Date: Tue, 5 Aug 2008 22:43:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Adrian Bunk <bunk@kernel.org>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Kconfig no longer outputs a .config with freshly updated defconfigs
Message-ID: <20080805204332.GB5464@uranus.ravnborg.org>
References: <1217693013.2328.22.camel@localhost.localdomain> <20080802192646.GR19682@cs181140183.pp.htv.fi> <20080803080019.GA13265@uranus.ravnborg.org> <20080803100732.GA7442@cs181140183.pp.htv.fi> <20080804210848.GA29902@uranus.ravnborg.org> <Pine.LNX.4.64.0808050435320.6791@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808050435320.6791@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 04:50:16AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Mon, 4 Aug 2008, Sam Ravnborg wrote:
> 
> > > Why can't we simply always write the .config?
> > 
> > Hi Adrian.
> > 
> > I just pushed a patch that does this.
> 
> If I see it correctly that's not quite correct either. The old 
> silentoldconfig does a few things differently than a normal config target, 
> because it's a special target called by Kbuild when needed:
> 
> - bail out if input is needed but stdio is not a tty
> - silent mode
> - update .config only as needed
> - always update autoconf
> 
> With the change to make the silent mode the default, the "silent" name has 
> become a little obsolete and should probably be renamed, but whatever the 
> name above actions should still be done if called by Kbuild internally.

silentoldconfig now always update .config - and that a bug.
I was too hasty ghere - sorry.
Will fix it during the weekend.

	Sam
