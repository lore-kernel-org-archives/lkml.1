Return-Path: <linux-kernel-owner+w=401wt.eu-S965508AbXCLKag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbXCLKag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXCLKag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:30:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965508AbXCLKaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:30:35 -0400
To: Troy Benjegerdes <hozer@hozed.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Debugging x86_64 apic & bootup problems on the Cray XD1
References: <20070311223802.GB27026@narn.hozed.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Mar 2007 12:29:54 +0100
In-Reply-To: <20070311223802.GB27026@narn.hozed.org>
Message-ID: <p737itmaedp.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Troy Benjegerdes <hozer@hozed.org> writes:

> I am attempting to make a 2.6.20 kernel boot on a Cray XD1 node with a
> Mellanox InfiniBand card installed, however both the ancient supplied
> cray 2.6.5 suse derivative, and a 2.6.20 kernel I just booted fail
> on APIC initialization.
> 
> Below is a diff of boot-up logs from a node without the mellanox IB
> card, and one with.. Does anyone have some pointers on debug options I
> should start turning on?

apic=debug

But most likely it's not related to the APICs anyways.

 Is there some way I can disable some of the
> memory regions in the infiniband card via some early PCI init code
> before APIC's are set up?

Sure, you can code anything. There isn't a standard way to do this
though.

-Andi
