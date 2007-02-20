Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXBTJlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXBTJlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXBTJlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:41:19 -0500
Received: from mail.suse.de ([195.135.220.2]:37627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789AbXBTJlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:41:19 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: x86_64: up to 255 or 256 CPUs?
Date: Tue, 20 Feb 2007 10:35:38 +0100
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070220000647.GI13958@stusta.de> <20070220004218.GO21484@holomorphy.com>
In-Reply-To: <20070220004218.GO21484@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201035.38874.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 01:42, William Lee Irwin III wrote:
> On Tue, Feb 20, 2007 at 01:06:47AM +0100, Adrian Bunk wrote:
> > Quoting arch/x86_64/Kconfig:
> > <--  snip  -->
> > ...
> > config NR_CPUS
> >         int "Maximum number of CPUs (2-256)"
> >         range 2 255
> > ...
> > <--  snip  -->
> > cu
> > Adrian
> 
> The broadcast APIC ID clashes with the 256th cpu.

Yes 255 is theory. But we don't know if it actually works anyways because
it has been never tested.

-Andi
