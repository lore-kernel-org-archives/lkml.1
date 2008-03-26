Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYCZFSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYCZFSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYCZFSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:18:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYCZFSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:18:24 -0400
Date: Tue, 25 Mar 2008 22:23:46 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Van De Ven, Arjan" <arjan@linux.intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fixing the main programmer thinko with the device model
Message-ID: <20080326052346.GA29413@kroah.com>
References: <1206373188.3494.36.camel@localhost.localdomain> <20080324175844.GA13816@kroah.com> <1206382109.3494.69.camel@localhost.localdomain> <87ve3bi0s3.fsf@basil.nowhere.org> <20080326041631.GB28224@kroah.com> <1206508069.24783.16.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206508069.24783.16.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 06:07:49AM +0100, Kay Sievers wrote:
> On Tue, 2008-03-25 at 21:16 -0700, Greg KH wrote:
> > On Tue, Mar 25, 2008 at 10:57:32AM +0100, Andi Kleen wrote:
> > > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > > > 
> > > > That's true, but irrelevant (and also soon to be untrue if we get rid of
> > > > the scsi_device class as you and Kay keep requesting).  The two calls
> > > > release references on the actual embedded generic device, it's nothing
> > > > to do with entangled lifetime rules.
> > > 
> > > <heretic thought>Has anybody ever considered just doing away with 
> > > the problematic and bug prone and tricky reference counts for kobjects 
> > > and switch to a simple garbage collector for them?
> > 
> > Sure, I have no objection to that.  It's just that the reference count
> > "issue" really doesn't seem to be one on sanely designed busses :)
> 
> Hmm, what is a "???simple garbage collector" here? How could one determine
> "reachability" of objects, means: at what point of time do objects
> actually become "garbage"? How could one trace in our current kernel
> code who still accesses an object, without doing refcounts?

I think in the end, it would be the same thing, so we should stick with
our current code, as that's exactly what the current kobject model now
implements :)

thanks,

greg k-h
