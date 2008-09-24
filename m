Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYIXS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYIXS7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYIXS7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:59:09 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:32451 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752202AbYIXS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:59:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IW3wl+jDQ4VHiuwWnd9As30em6zOtn70/gfOOioxvh4pNYLFPRsZpkL/Y14TJ1LHFtCwfQ7YhQiUcvaGMpzZTK1cFLqbfO2Gcyn6VyZ0O67EuGbSidgNTFnT9qPThw804mhq/UmvHCb+QPadbw1+EfAuWb+4MhE232Q5dcqeSac=  ;
X-YMail-OSG: mG1n0t4VM1mqr3.ehoTAonQp_zLMtfVsORDm.iJGGtDyrVFr_48e_yZTy8o5L9d4XorzFGW7N6Gx4g4LGvuzxLjGCEolzOioykV4up0D56NuRk2a1y4cDlTldqQ7cA3HRgQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB =?iso-8859-1?q?Host=09Controller?=
Date: Wed, 24 Sep 2008 11:59:03 -0700
User-Agent: KMail/1.9.9
Cc: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leoli@freescale.com, timur@freescale.com
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru> <20080923225730.GB13617@oksana.dev.rtsoft.ru> <48DA1544.5010307@ru.mvista.com>
In-Reply-To: <48DA1544.5010307@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809241159.04427.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Sergei Shtylyov wrote:
> 
> >>   ... then the root hub emulation is completely pointless.
> >>     
> >
> > It isn't. We always should emulate the root hub. The root hub
> > is part and parcel of any USB Host. Even the one-port one.
> 
>    Hm, maybe that's what USB core thinks (because UHCI/OHCI/EHCI all 
> have it) but e.g. MUSB doesn't have the root hub registers...

Only the OHCI registers have bit positions matching what the USB
spec says for hub status bits.  Everything else, including musb_hdrc,
has the relevant status encoded in other bits.


> I looked at the core and figured that USB core seems to use the root hub 
> interface for port PM, etc. and expects it to bee present, so it seems 
> unavoidable indeed... :-/

Or more fundamentally:  for enumeration.  "Unavoidable" is correct.  ;)

