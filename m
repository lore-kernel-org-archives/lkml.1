Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbYBFXTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbYBFXTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbYBFXQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:16:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36271 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763989AbYBFXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:16:38 -0500
Date: Wed, 6 Feb 2008 15:10:20 -0800
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [stable] The SMP alternatives code breaks exception fixup?
Message-ID: <20080206231020.GB12395@kroah.com>
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de> <47964FD5.6020801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47964FD5.6020801@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 03:19:33PM -0500, Chuck Ebbert wrote:
> On 01/22/2008 07:35 AM, Thomas Gleixner wrote:
> > 
> > That's a long standing bug in both the PI futex and the standard futex
> > code. Needs to go to stable as well.
> > 
> 
> Here's the 2.6.23 version:
> 
> 
> Subject: x86: fix missing exception entry for SMP alternatives in futex macros
> From: Thomas Gleixner <tglx@linutronix.de>

I don't see this in Linus's tree, am I just missing it?  Do you have a
git commit id?

thanks,

greg k-h
