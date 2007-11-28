Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbXK1Sbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbXK1Sbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXK1Sbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:31:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:8157 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbXK1Sbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:31:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HW8GiQm3OxHcMLqXuUh9is+vj5fGTb8Ah9bzC75HjrSPLmag2PM9zz6TWHBakItp5oMuNGNXcSvRrVuZzDFhWZZ7wCAyJ92+2U2/aKEI8u2IgYFqEu0Qdao344slOmX1Y3oGTQ4QVf3McW3KU+KUw6urWtOvXrbzr+05rtbPho0=
Message-ID: <19f34abd0711281031r3d9ac97bw800aaeec87e86816@mail.gmail.com>
Date: Wed, 28 Nov 2007 19:31:35 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <474D100E.1000101@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474C34CC.6060509@gmail.com> <474D100E.1000101@student.ltu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Nov 28, 2007 7:51 AM, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Vegard Nossum wrote:
> > +static int
> Not 'static bool'?
> > +page_is_tracked(struct page *page)
> Why not returning 'false' and 'true'?

Sorry, I am not used to using bool in C :-) I will change this if bool
is preferred in kernel code.

> > +static unsigned int
> > +opcode_get_size(const uint8_t *opcode)
> Are we not using 'u8' in the kernel?

Actually, I don't see any reason to use u8 when uint8_t is already
standard and used in other places in the kernel.

Thanks for the other comments! I will make the necessary changes for
the next version.

> cu
> Richard Knutsson

Vegard
