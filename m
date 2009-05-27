Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbZE0PmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbZE0PmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZE0Plv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:41:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZE0Plu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=X9CKOSuoPwYUrx35WuDRVoNFqG99KnV2aFAY4QAx9XTA2oY4+0wSTA3N47E1KVcLEe
         FCAkazrG2xXQvafQofx+qlVKtHYJrWUhpwcVjgnCKIUpNCtq6Xjh+NV5nY9dPM+NsEi1
         KQpaOn/qKoOo+e7eAZYERY9NSejNG4/EG15o8=
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>
	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	<20090527150527.GK6805@pengutronix.de>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 27 May 2009 17:41:47 +0200
In-Reply-To: <20090527150527.GK6805@pengutronix.de> (Robert Schwebel's message of "Wed\, 27 May 2009 17\:05\:27 +0200")
Message-ID: <87vdnm8sec.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Robert" == Robert Schwebel <r.schwebel@pengutronix.de> writes:

Hi,

 Robert> - The whole concept is based on the assumption that bindings
 Robert> are defined *once*, then never to be changed again. As this
 Robert> is not true (check MPC5200 to find out what I mean), oftree
 Robert> wreckage is *the* main cause of new kernels not working on
 Robert> old bootloaders any more. Is there a solution of this
 Robert> problem? I have not seen a good idea how to avoid the
 Robert> constant change in definitions.

Just bundle the .dtb with the kernel and they'll always be in sync. I
know this isn't really in the spirit of OF, but currently imho the
only realistic solution.

I did a (nacked) patch to do this with the multi-image support in
U-Boot some time ago:

http://patchwork.ozlabs.org/patch/589/

 Robert> - The oftree layering is fundamentally broken. We already
 Robert> have a sane abstraction for arbitrary hardware in the kernel:
 Robert> platform devices.  Why not instanciate platform devices from
 Robert> a generic oftree core?

 Robert> - Platform data makes it possible to store function
 Robert> pointers. There is no equivalent to this concept in
 Robert> oftree-land.

Yeah.

-- 
Bye, Peter Korsgaard
