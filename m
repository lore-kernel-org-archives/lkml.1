Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZG0WiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZG0WiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZG0WiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:38:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZG0WiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:38:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LLax8rxN8fBM/2DCB/Tl9CziTVl5T3PBmpOCV4uyDsoc0DzYRJY7V7xG3QICMviip
	OB/g8JEF9EjZd9Dt1F2og==
Date: Mon, 27 Jul 2009 15:38:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.1.10.0907271740090.27697@gentwo.org>
Message-ID: <alpine.DEB.2.00.0907271533070.23587@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org> <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271740090.27697@gentwo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Christoph Lameter wrote:

> My prosal was to use the size and objsize parameters. You would only have
> to call calculate_sizes() twice when the comparison of the order of size
> and objsize would be different.
> 
> Doing so would simplify additing future flags. If you do your own
> calculations (like in the patch) then you have to replicate the size
> calculation from calculate_sizes() somehow. Is the duplicate calculation
> really accurate regarding alignment and other special casing?
> 

Ok, fair enough.  It seems like a matter of taste in implementation but 
your proposal is also more extendable than mine, and I'm definitely not 
going to argue your taste vs. mine when it comes to slub :)

I'll write an incremental patch on top of Pekka's for-next branch to 
implement your idea.
