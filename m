Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbXK0XRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbXK0XRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXK0XRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:17:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXK0XRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:17:37 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2/3] x86: clean up bitops-related warnings
Date: Wed, 28 Nov 2007 00:17:33 +0100
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071127230124.271668615@goop.org> <20071127230130.508648745@goop.org>
In-Reply-To: <20071127230130.508648745@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711280017.33344.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 00:01:26 Jeremy Fitzhardinge wrote:
> Add casts to appropriate places to silence spurious bitops warnings.

Looks a bit ugly. Perhaps it would be better to define standard wrappers

clear_bit_unaligned/any/bettername() etc. ?

-Andi
