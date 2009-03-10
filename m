Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZCJCdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZCJCdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZCJCd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:33:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:3735 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZCJCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TL8Xz1o/CqViDF5jmhV9eZL07B1PDPEf7bUilOAWu93bjCqCSWbUMUd2RWwa21DlR9
         waTutN1+TiCKHksMdgg/Y7jrnRS1fyQ2ve5Q/bnrocR+lMWlbO8d8TN7KDwckTP7A1k7
         tWDAPNEKBcEL0i2/Gu+5xkqYHoMWufXOmsExw=
Subject: Re: [Bug #12806] i915 broken STR
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1236651832.10190.20.camel@gaiman>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.QeB.sUarJB@chimera> <1236405187.7409.2.camel@brick>
	 <200903072228.47358.rjw@sisk.pl>  <1236651832.10190.20.camel@gaiman>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 19:33:22 -0700
Message-Id: <1236652402.12423.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 19:23 -0700, Eric Anholt wrote:
> On Sat, 2009-03-07 at 22:28 +0100, Rafael J. Wysocki wrote:
> > On Saturday 07 March 2009, Harvey Harrison wrote:
> > > On > > This looks to have been a case of old-userspace..upgrading to
> > > xorg-intel-video 2.6.1 (ubuntu Jaunty Alpha5) fixes STR here.
> > 
> > Well, thanks, but I'm not really sure if this is a good news.
> > 
> > Jesse, Eric, does it mean we now break resume on anything earlier than 2.6.1
> > on the Harvey's hardware?
> 
> There's not much information (dmesg, Xorg.0.log) with this bug -- I'm
> guessing he's using KMS, given that that commit was where the problems
> started.  If so, yes, you really do need good userland for KMS to work.
> 

Yep, turns out I had KMS turned on in my config...I thought I'd disabled
it, sorry for the noise.

Harvey

