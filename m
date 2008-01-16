Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYAPU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYAPU7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYAPU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:59:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:45531 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYAPU7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:59:15 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: fix detection of CONSTANT_TSC bit for AMD CPUs
Date: Wed, 16 Jan 2008 21:59:10 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <20080116194606.GB11244@alberich.amd.com>
In-Reply-To: <20080116194606.GB11244@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801162159.11012.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We have to set c->x86_power in early_identify_cpu to properly detect
> the CONSTANT_TSC bit in early_init_amd.

Hmm this definitely worked here when I wrote the patches. Must have been a merge
mistake later. I remember someone changed the early CPU init around severly
at some point and I might have not correctly forward merged my changes
with this. In general it is pretty tough to keep up with git-x86 currently.
Sorry about that.

-Andi
