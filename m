Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYLKUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYLKUqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbYLKUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:46:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:1452 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbYLKUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AJLrIa6zeDolNJs9fKwBoWcykIXO/4e7Jw6zxzClxh8AHL7KtszQwUqqN47zpnCwA6
         +FtxT6LLdzacx6pAEJEiP3NBxhiBhPX3zR1jWMrFO3kApa88a2AEOzB6Fi3Aid776sCR
         VHSLhEOwBlmSbMf3BD2/epEfap5OrlPDSA1Ow=
Message-ID: <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
Date: Thu, 11 Dec 2008 22:46:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linux 2.6.28-rc8
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Frans Pop" <elendil@planet.nl>, "Eric Anholt" <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Yinghai Lu" <yinghai@kernel.org>
In-Reply-To: <20081211203604.GA14817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	 <49407CE1.9090600@googlemail.com>
	 <1228979963.3254.8.camel@gaiman.anholt.net>
	 <200812111707.20857.elendil@planet.nl>
	 <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
	 <20081211163548.GA11859@elte.hu>
	 <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain>
	 <20081211203604.GA14817@elte.hu>
X-Google-Sender-Auth: 754dce38ac165400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Dec 11, 2008 at 10:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> ok. In this case i'd suggest we should just remove the warning. People do
> get scared by needless kernel stack dumps - no matter whether it's marked
> informational or not.
>
> So how about the patch below, queued up in tip/x86/debug? Arjan, what do
> you think?

How come we don't put it under CONFIG_X86_DEBUG or something and hide
somewhere in the "Kernel debugging" menu?

                Pekka
