Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYFKOwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYFKOwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbYFKOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:52:11 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40384 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYFKOwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:52:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18511.57661.944934.513223@harpo.it.uu.se>
Date: Wed, 11 Jun 2008 16:29:17 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ian Kent <raven@themaw.net>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH] autofs4: fix 32-bit userspace vs 64-bit
	kernel	communications
In-Reply-To: <1213190100.4994.54.camel@raven.themaw.net>
References: <484FA0B8.2000002@openvz.org>
	<1213187579.4994.25.camel@raven.themaw.net>
	<484FC94E.1000209@openvz.org>
	<1213190100.4994.54.camel@raven.themaw.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent writes:
 > What about other arches offer 32-bit within a 64-bit environment (has
 > this been the case on sparc64 at some point)?
 > What about the compiler padding on these?

Both ppc64 and sparc64 commonly have 32-bit userspaces.
But 64-bit and mixed 32/64-bit userspaces are of course possible.
