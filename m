Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYCZErx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYCZErx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYCZErq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:47:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYCZErp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:47:45 -0400
Date: Tue, 25 Mar 2008 21:16:31 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       "Van De Ven, Arjan" <arjan@linux.intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fixing the main programmer thinko with the device model
Message-ID: <20080326041631.GB28224@kroah.com>
References: <1206373188.3494.36.camel@localhost.localdomain> <20080324175844.GA13816@kroah.com> <1206382109.3494.69.camel@localhost.localdomain> <87ve3bi0s3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ve3bi0s3.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 10:57:32AM +0100, Andi Kleen wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > 
> > That's true, but irrelevant (and also soon to be untrue if we get rid of
> > the scsi_device class as you and Kay keep requesting).  The two calls
> > release references on the actual embedded generic device, it's nothing
> > to do with entangled lifetime rules.
> 
> <heretic thought>Has anybody ever considered just doing away with 
> the problematic and bug prone and tricky reference counts for kobjects 
> and switch to a simple garbage collector for them?

Sure, I have no objection to that.  It's just that the reference count
"issue" really doesn't seem to be one on sanely designed busses :)

thanks,

greg k-h
