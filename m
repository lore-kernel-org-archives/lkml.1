Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYJAGN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYJAGN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJAGNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:13:47 -0400
Received: from colo.lackof.org ([198.49.126.79]:47615 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYJAGNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:13:46 -0400
Date: Wed, 1 Oct 2008 00:13:28 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
	in quirk_system_pci_resources()
Message-ID: <20081001061328.GD7348@colo.lackof.org>
References: <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu> <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 12:51:07PM -0700, Linus Torvalds wrote:
....
> But I think we could add a separate notion of a dependancy point, and have 
> a setup where we describe "initcall X needs to happen before point A" and 
> "initcall Z needs to happen after point A".
> 
> And then we can create a separate set of these dependency points, so that 
> X and Y don't have to know about each other, they just have to have some 
> knowledge about some common synchronization point - one that exists 
> regardless of whether X or Y are even compiled in!

We already do this today. :)
Definitions are in include/linux/init.h.
Point A would be "early" ("run before initialing SMP")
The rest could use better definitions and AFAICT aren't that much better
than being named "Point B".

hth,
grant
