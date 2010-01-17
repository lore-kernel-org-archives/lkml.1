Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398Ab0AQXFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0AQXFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228Ab0AQXFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:05:37 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40757 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0AQXFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hyCpVd5h1UiND0mgCTdRDo0JhHUahG5tI6j3O/O+I0daAseEd4WtKMUiKx3dl4sfNM
         yKEbrsxZEZtieDI8fhHrm7Z93ur9/pY2s+dBEHhylqy6TG9CnKZM2HWFzJVH/BAke+Eq
         OIPMGqeMQjn7kYt+raIMdI3x95wIfFctbJlnw=
Date: Mon, 18 Jan 2010 00:05:31 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100117230531.GC3161@del.dom.local>
References: <4B47A81B.5040601@majjas.com>
 <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local>
 <4B48CC2C.2090403@majjas.com>
 <4B4E2F89.2050606@majjas.com>
 <20100113210908.GA3065@del.dom.local>
 <4B4E3834.3000609@majjas.com>
 <4B533A46.9050600@majjas.com>
 <20100117221746.GA3161@del.dom.local>
 <4B53906B.2020608@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B53906B.2020608@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 05:34:19PM -0500, Michael Breuer wrote:
> On 1/17/2010 5:17 PM, Jarek Poplawski wrote:
> >On Sun, Jan 17, 2010 at 11:26:46AM -0500, Michael Breuer wrote:
> >>On 01/13/2010 04:16 PM, Michael Breuer wrote:
> >>>On 1/13/2010 4:09 PM, Jarek Poplawski wrote:
> >>>>On Wed, Jan 13, 2010 at 03:39:37PM -0500, Michael Breuer wrote:
> >>>>
> >>Update: after leaving the system up for a few days, I hit the DMAR
> >>error again.
> >My proposal is to send some summary as a new thread, with dmar in the
> >subject, and cc-ed dmar maintainers.
> >
> Not sure I agree. The symptoms are identical to those I hit without
> DMAR earlier on. Also, as this issue only happens when there is high
> receive load, I'm thinking there's some sort of race between TX and
> RX within the sky2 driver, or hardware. I think that DMAR is
> correctly catching the error.

Hmm... OK, then let's wait with this report and go back to testing
it "really really long" ;-) without DMAR, and maybe without the
last Stephen's patch either? (So only the two things in the current
linux-2.6.)

Jarek P.
