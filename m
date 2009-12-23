Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZLWOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZLWOKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZLWOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:10:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63071 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbZLWOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GHpa+CuTK36dPQmJ4kPhxWMEZgJO5oW7ZSTdThy7zD4XmrsZSgBGW34GVagaUeKuBC
         +DbH0uq9SyAZMokpJR/9r/VF+P6FnmVTNhdlpQHC0+YSERpzNZRXARzN0C80kTGaPsJv
         c7gY3Z/dqO/eV69/MJ5geRaai55xXvkPaaPzw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Date: Wed, 23 Dec 2009 15:08:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
References: <4B1D4F29.8020309@gmail.com> <200912231407.20130.bzolnier@gmail.com> <4B321B9F.6030707@redhat.com>
In-Reply-To: <4B321B9F.6030707@redhat.com>
MIME-Version: 1.0
Message-Id: <200912231508.25355.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009 02:31:11 pm Avi Kivity wrote:
> On 12/23/2009 03:07 PM, Bartlomiej Zolnierkiewicz wrote:
> >
> >> That is a very different situation from the AlacrityVM patches, which:
> >>
> >>   - Are a pure software concept and any compatibility mismatch is
> >>     self-inflicted. The patches are in fact breaking the ABI to KVM
> >>     intentionally (for better or worse).
> >>      
> > Care to explain the 'breakage' and why KVM is more special in this regard
> > than other parts of the kernel (where we don't keep any such requirements)?
> >    
> 
> The device model is exposed to the guest.  If you change it, the guest 
> breaks.

Huh?  Shouldn't non-vbus aware guests continue to work just fine?

> > I certainly missed the time when KVM became officially part of core ABI..
> >    
> 
> It's more akin to the hardware interface.  We don't change the hardware 
> underneath the guest.

As far as my limited understanding of things go vbus is completely opt-in
so it is like adding new real hardware to host.  Where is the problem?

--
Bartlomiej Zolnierkiewicz
