Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232Ab0ANV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0ANV1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064Ab0ANV1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:27:43 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:54276 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754933Ab0ANV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:27:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hqi6MVBBKm+G3dx/HMAYMDn5982RvQNMZvZAlnCi4UbP8fpCs5QKkeHYtjOGHdVS5HauvUv2A3PSeDsLiIxRAX7hRwxgQrzYcPwIGTTXAF/fidaJK9NQkOrjQLgWu2zC;
Date: Thu, 14 Jan 2010 13:27:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Peter Clifton <pcjc2@cam.ac.uk>, airlied@linux.ie,
       intel-gfx@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100114132719.5b2151c6@jbarnes-piketon>
In-Reply-To: <20100114211610.GA2030@emergent.ellipticsemi.com>
References: <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon>
	<4B4E403C.1050509@cs.helsinki.fi>
	<20100113165530.2a7e7645@jbarnes-piketon>
	<4B4F6D5F.10008@cs.helsinki.fi>
	<20100114193118.GA1203@emergent.ellipticsemi.com>
	<84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	<20100114202803.GA1749@emergent.ellipticsemi.com>
	<20100114124802.025bbcae@jbarnes-piketon>
	<1263502711.16937.5.camel@pcjc2lap>
	<20100114211610.GA2030@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 16:16:10 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> Is it really a defective BIOS?  I don't have my laptop handy right
> now, but the lower refresh mode is reported in the EDID and can be set
> successfully (no idea if the change actually does anything).  However,
> there is a visible artifact whenever a transition occurs.

No, it's possible the BIOS has it right but we're failing to transition
gracefully.

Your platform should support automatic hardware frequency switching.
You could try disabling that (clear the has_pipe_cxsr field of your
driver struct in i915_drv.c) and see if the manual method works for you.

-- 
Jesse Barnes, Intel Open Source Technology Center
