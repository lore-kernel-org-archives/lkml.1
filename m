Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYARSfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYARSfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764855AbYARScW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:32:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763176AbYARScT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:32:19 -0500
Date: Fri, 18 Jan 2008 13:27:27 -0500
From: Dave Jones <davej@redhat.com>
To: Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64
	identity map and kernel text
Message-ID: <20080118182727.GB10167@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, ak@muc.de,
	ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
	airlied@skynet.ie, mingo@elte.hu, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@infradead.org,
	"Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11912.1200005441@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 05:50:41PM -0500, Valdis.Kletnieks@vt.edu wrote:

 > (Personally, I keep a copy of Arjan's "restrict devmem" patch from Fedora
 > around, so I guess that says which camp I belong in, and the fact it's a Fedora
 > patch and not mainstream says something too...)

The way that patch is right now (and has been for some time) is kind of nasty,
and could use cleaning up.  I made a half-assed attempt at improving it
a little over xmas, but it could rewriting from scratch.
That's the only reason I never bothered pushing it (and I assume, the reason
that Arjan didn't push it when he wrote the original).

     Dave

--
http://www.codemonkey.org.uk
