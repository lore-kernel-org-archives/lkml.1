Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZE2JsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZE2JsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZE2JsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:48:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36775 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZE2JsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:48:00 -0400
Date: Fri, 29 May 2009 11:47:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rms <rms@gnu.org>
Cc: Theodore Tso <tytso@mit.edu>, joseph.cihula@intel.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com, gnu@toad.com
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090529094753.GA21928@elf.ucw.cz>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com> <20090524194231.GB1337@ucw.cz> <E1M8kJQ-0000W3-TE@fencepost.gnu.org> <20090526023105.GB27648@mit.edu> <E1M9Mig-0003Q4-S1@fencepost.gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M9Mig-0003Q4-S1@fencepost.gnu.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-05-27 13:15:14, rms wrote:
> This scheme must be very different from anything I've heard of before.
> Can you tell me where to find a description?
> I want to study whether it really avoids being affected by GPLv3,
> and how we can fight against it.

Some description is here:
http://en.wikipedia.org/wiki/Trusted_Execution_Technology .

And yes, I believe it avoids GPLv3: TXT allows user (I _hope_ it is
root-only) to boot tamper-free sandbox. As long as Windows (or
something) runs in the sandbox, I believe even GPLv3 would allow that.

OTOH... I do not think mainline kernel should support this. It does
not add anything to the user's security, and allows all kinds of nasty
DRMs.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
