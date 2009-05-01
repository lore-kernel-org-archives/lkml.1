Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZEAHx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZEAHx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 03:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZEAHxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 03:53:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33611 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZEAHxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 03:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=CIwQJFNqvdXFiunxulORzIU+s8R/vwkekquWuL9i8vs4u2mF0VnKaH1vf6Z/XlBBbk
         Dy1C6AgZd/VZEymr97B+x6Hz8OEPgWwl+rikIDveKwvygz/nq5qtAAqV2c8DenCkOCm3
         CLhFzZBas+I3HhiyVbaUTthyOpPQ40X1tdISw=
Date: Fri, 1 May 2009 09:53:11 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       Ben Woodard <woodard@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090501075311.GA14176@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Aristeu Rozanski <aris@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
	tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
	linux-kernel@vger.kernel.org, Ben Woodard <woodard@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab> <20090430124716.GW23223@one.firstfloor.org> <20090430144756.GA25200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090430144756.GA25200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I thought I should summarize some points on the design direction, which,
in my impression are what all the parties involved more or less would
agree on:

* mce interrupt delivers, if EDAC compiled in, the required batch of
dumped MSRs to chipset/CPU specific EDAC driver. Aristeu, I guess you
guys have some code on that, right?

* EDAC module decodes MCE info, computes the DIMM label out of
that. Additional hw setup stuff like memory hoisting/interleaving,
ganged/unganged MC mode, testing infrastructure like DRAM error
injection and all that pertaining to the specific hw is handled by the
EDAC module.

* If EDAC not enabled, mce operates as before.

Comments/suggestions?

Hit me! :)

-- 
Regards/Gruss,
    Boris.
