Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZHKPgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZHKPgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZHKPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:36:46 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37548 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZHKPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:36:45 -0400
Date: Tue, 11 Aug 2009 17:36:33 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090811153633.GC32658@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8189D9.4080709@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> Not the same question, but I'd agree - that would probably break the  
> current model I have proposed. *However*, providing a resource  
> management layer as you have proposed above the basic resource  
> management my API provides would resolve that without added complexity  
> in the bridge drivers themselves.

It wouldn't break it, the model simply couldn't give you more
than 8 windows-->8 devices.

I think it should be the bridge the one that manages its
own resources, not someone else.
I'm coding a layer that works this way, we'll see how it looks.

> Yes. If I understand you correctly, your saying that management of the  
> devices in the VME address space is a system configuration issue.

It obviously is. We cannot impose the users where they should
plug their devices or which pins on the boards they should
tweak. They build their crates --> they tell the kernel about
them.
