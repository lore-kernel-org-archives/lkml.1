Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbXFDVWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbXFDVWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbXFDVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:22:35 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:54728 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbXFDVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hgxY9SDLV+t3+J6VuTEDdBq8MaxDMmCsO3FQHJoUuFc8lgUVsBq3aQmMhQo4fJX5Bd+9bHCr/n6xdCBzB99PFDMd4kkwxqqLisuEMdeZubtvkX/Wlt8QhKRVdpMrDhP3PSbVGAPD0GUBWtCw934iTGn3loUc94XpEdKyjBjS8Kw=
Date: Mon, 4 Jun 2007 23:22:07 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070604212207.GA22365@dreamland.darkstar.lan>
References: <20070603213432.GA3075@dreamland.darkstar.lan> <4663DCE9.3000107@qumranet.com> <20070604202248.GA18668@dreamland.darkstar.lan> <46647B3E.2090205@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46647B3E.2090205@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Jun 04, 2007 at 11:51:10PM +0300, Avi Kivity ha scritto: 
> > While doing repeated tests with the installer I ran into another
> > (unrelated) problem. Sometimes the guest kernel hangs at boot at:
> >
> > NET: Registered protocol family 2
> >
> > with any kind of networking options (except for -net none, which works).
> > With -no-kvm it boots with any networking option.
> >
> >   
> 
> Can you try to pin the guest on a single core with taskset:
> 
>    taskset 1 qemu ...

Doesn't help. What works is 'nolapic', i.e. disabling the local APIC on
the guest kernel.
I've also tried disabling TSC (notsc) and forcing PIT as the clocksource
(clocksouce=pit clock=pit); neither of them helped.

Luca
-- 
Il dottore mi ha detto di smettere di fare cene intime per quattro.
A meno che non ci siamo altre tre persone.
