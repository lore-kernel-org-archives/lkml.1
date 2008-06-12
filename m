Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYFLC4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYFLC4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYFLC42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:56:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39577 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYFLC42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:56:28 -0400
X-Sasl-enc: vU8CuXRTY+HZBr2bMrZStD8945IkPMmTX27IW24Hm7Wi 1213239386
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs 64-bit
	kernel	communications
From: Ian Kent <raven@themaw.net>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
In-Reply-To: <18511.57661.944934.513223@harpo.it.uu.se>
References: <484FA0B8.2000002@openvz.org>
	 <1213187579.4994.25.camel@raven.themaw.net> <484FC94E.1000209@openvz.org>
	 <1213190100.4994.54.camel@raven.themaw.net>
	 <18511.57661.944934.513223@harpo.it.uu.se>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 10:52:28 +0800
Message-Id: <1213239148.4994.70.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 16:29 +0200, Mikael Pettersson wrote:
> Ian Kent writes:
>  > What about other arches offer 32-bit within a 64-bit environment (has
>  > this been the case on sparc64 at some point)?
>  > What about the compiler padding on these?
> 
> Both ppc64 and sparc64 commonly have 32-bit userspaces.
> But 64-bit and mixed 32/64-bit userspaces are of course possible.

I believe that both these archs have the same alignment characteristics
a x86_64. Can anyone confirm that?

Ian


