Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXJKLYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXJKLYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXJKLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:23:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48583 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbXJKLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:23:50 -0400
Date: Thu, 11 Oct 2007 13:25:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: "Andrew Morton <akpm@linux-foundation.org>Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 vDSO linker script cleanup
Message-ID: <20071011112519.GA8393@uranus.ravnborg.org>
References: <20070924110417.BD06A4D0325@magilla.localdomain> <20071011074037.9C15C4D026B@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011074037.9C15C4D026B@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 12:40:37AM -0700, Roland McGrath wrote:
> This replaces my earlier patch by the same title:
> x86_64-vdso-linker-script-cleanup.patch

Hi Roland.

I have been through a number of arch linker scripts lately
introducing a consistent style.
I decided upon a style matching what we have for c today:
indent with one tab, nothing after starting {,
indendt after starting { etc.

Would you mind introducing same style for the vdso linker script?

I could do it just fine but I'm afraid to clash with your work.

None of my clean-up patches has hit -linus yet but I
assume most will do so during the merge window. All arch maintainers
has accepted the cleanup patches.

Latest in the series was parisc - patch is here:
http://lists.parisc-linux.org/pipermail/parisc-linux/2007-October/031967.html

	Sam
