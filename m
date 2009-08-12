Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZHLJyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZHLJyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbZHLJyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:54:44 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:48147 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbZHLJyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:54:44 -0400
Date: Wed, 12 Aug 2009 11:54:36 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090812095436.GC2604@braap.org>
References: <20090810193849.GA3055@braap.org> <4A812BCE.3010003@gefanuc.com> <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org> <4A819E80.90103@gefanuc.com> <20090811204835.GA9910@braap.org> <4A828395.9040006@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A819E80.90103@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> There is a further device situated between the two.
> > How do you now protect the registers of this device from
> > > accidental/malicous/buggy behaviour from your board, since
> this region of the VME bus is now enabled for transfers
> in the PCI IO Mem space?

The kernel is not designed to work with buggy hardware--that
would be insane, we've got more than enough dealing with our
own bugs. However when there's no other solution (e.g.
hardware can't be fixed for whatever reason), fixes on a
per-case basis may be applied.

E.
