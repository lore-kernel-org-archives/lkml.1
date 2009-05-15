Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbZEOM3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbZEOM3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763596AbZEOM0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:26:47 -0400
Received: from thunk.org ([69.25.196.29]:57723 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762128AbZEOM0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:26:46 -0400
Date: Fri, 15 May 2009 08:26:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Cihula, Joseph" <joseph.cihula@intel.com>,
       James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090515122644.GA9173@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	James Morris <jmorris@namei.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"arjan@linux.intel.com" <arjan@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	"chrisw@sous-sol.org" <chrisw@sous-sol.org>,
	"jbeulich@novell.com" <jbeulich@novell.com>,
	"peterm@redhat.com" <peterm@redhat.com>,
	"Wei, Gang" <gang.wei@intel.com>,
	"Wang, Shane" <shane.wang@intel.com>, John Gilmore <gnu@toad.com>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com> <20090515120748.GF6816@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515120748.GF6816@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, see this slide set:

http://invisiblethingslab.com/resources/bh09dc/Attacking%20Intel%20TXT%20-%20slides.pdf

For more details about why a TCPA-style solution (referred to in the
slide set as a Static Root of Trust Measurement) doesn't really work
for widespread consumer-usable DRM, where as a Dynamic Root of Trust
Measurement (DRTM) scheme, such as provided by TXT, makes this be a
much more tractable solution.

Also see their early results for attacking TXT via bugs in the SMM
Bios.  The one thing which is not discussed much in this slide decks
is the hardware implemented features which lock out the Host OS from
being able to read or modify memory used by the trusted code running
in the secure VM (which must be locked into memory) once the SENTER
instruction is given.

Obviously, yes, it's all under the user's control --- you don't have
to boot a TXT VM image.  On the other hand, you don't have to have
access to your on-line banking, medical records, or watch a movie from
Hollywood, and in the future, it might be that running TXT is the only
way to do that.  (The argument that it's always under the user's
control is a standard line used by people defending DRM --- after all,
you don't have to listen to the protected music, or watch the
protected movie.  It shifts the ground from the question societal
question of "is DRM good for society", to a user freedom question,
which is always true --- of course, user's are also free to boycott
purchases of hardware that enable DRM; that is also their choice.)

	     	      	   	       	    - Ted
