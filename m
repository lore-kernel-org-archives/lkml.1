Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019Ab0AIBNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0AIBNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 20:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0AIBNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 20:13:10 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:44791 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752351Ab0AIBNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 20:13:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pYKNYbFyFTn+putqKosByNJrZV3a9xSzv4Yp1j0hF49S2Ze0cm9TR/nvyMDYF2Srb6WPXjS+8UiCT3umrKOqF5QmUIIssaQ15fCQKgbxywhg9s8IHBrOWGHQiwbBhRhP;
Date: Fri, 8 Jan 2010 17:13:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
Message-ID: <20100108171311.128c43d0@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001081648490.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl>
	<alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
	<20100108163217.341da699@jbarnes-piketon>
	<201001090146.17793.rjw@sisk.pl>
	<alpine.LFD.2.00.1001081648490.7821@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 16:50:57 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
> > 
> > Which is functionally equivalent to my patch, because
> > i915_suspend/resume() won't be called by drm_class_suspend/resume()
> > in the KMS case anyway.
> 
> Ahh, right you are - that class suspend function does a check for 
> DRIVER_MODESET, and only does the suspend/resume if it's not a
> MODESET driver.
> 
> Ok, so I withdraw my objections to your original patch - it's
> confusing, but that's just because DRM is such a horrible mess with
> subtle things.

Yeah the non-KMS paths just suck.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Though hopefully you can get the PCI driver registration working w/o
too much trouble; that would be even better.

-- 
Jesse Barnes, Intel Open Source Technology Center
