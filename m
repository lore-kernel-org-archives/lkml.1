Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZFEAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZFEAJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZFEAJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:09:27 -0400
Received: from solo.fdn.fr ([80.67.169.19]:49355 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZFEAJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:09:27 -0400
Date: Fri, 5 Jun 2009 02:09:10 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Tramnitz <christian@tramnitz.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090605000910.GQ8916@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Tramnitz <christian@tramnitz.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	David Miller <davem@davemloft.net>,
	"jeremy@goop.org" <jeremy@goop.org>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	"avi@redhat.com" <avi@redhat.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Keir Fraser <Keir.Fraser@eu.citrix.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
	Ian Pratt <Ian.Pratt@eu.citrix.com>,
	"xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
	ksrinivasan <ksrinivasan@novell.com>,
	"EAnderson@novell.com" <EAnderson@novell.com>,
	"wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
	Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu> <4A262F4B.8010404@tramnitz.com> <alpine.LFD.2.01.0906041151540.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0906041151540.4880@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds, le Thu 04 Jun 2009 11:53:45 -0700, a écrit :
> On Wed, 3 Jun 2009, Christian Tramnitz wrote:
> >
> > What a great idea, and while we're doing this let's also drop support
> > for legacy stuff like PATA and i8042 in mainline. Noone will need it
> > anyway because their successors are on the market for years... let's
> > just take it for granted that everyone is using SATA and USB nowadays!
> 
> Have you noticed how PATA and i8042 don't screw up anything else? 

Right.  We should get rid of all the HIGHMEM kmap crap that cripples all
the code.

Samuel
