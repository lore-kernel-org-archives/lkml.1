Return-Path: <linux-kernel-owner+w=401wt.eu-S1030417AbXCLPqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbXCLPqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030433AbXCLPqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:46:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39836 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417AbXCLPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:46:00 -0400
Date: Mon, 12 Mar 2007 16:45:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: _proxy_pda still makes linking modules fail
Message-ID: <20070312154558.GA16327@one.firstfloor.org>
References: <1173315479.12472.9.camel@qrnik> <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org> <20070312094805.GA11644@one.firstfloor.org> <45F56785.5070002@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F56785.5070002@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 07:45:25AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> Rusty's pda->per_cpu patch will deal with this once and for all; have
> >>     
> >
> > Not on x86-64.
> >   
> 
> Have you considered dropping pda in x86-64?  Segment based percpu
> doesn't really have any disadvantages.

Maybe.

> 
> >> you picked it up yet?
> >>     
> >
> > Not yet.
> >   
> 
> There will be interactions with my paravirt+xen patches, so I'm
> wondering if I should rebase onto those patches, or should we apply them
> later and fix everything up?

Applying them later is probably better

-Andi
