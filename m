Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbZHLKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbZHLKJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbZHLKJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:09:46 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:54872 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbZHLKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:09:45 -0400
Date: Wed, 12 Aug 2009 12:09:27 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090812100927.GA10800@braap.org>
References: <20090811144914.GB32658@braap.org> <4A8189D9.4080709@gefanuc.com> <20090811153633.GC32658@braap.org> <4A819130.5080802@gefanuc.com> <20090811154226.GD32658@braap.org> <4A819E80.90103@gefanuc.com> <20090811204835.GA9910@braap.org> <4A828395.9040006@gefanuc.com> <20090812095436.GC2604@braap.org> <4A829271.6000507@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A829271.6000507@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> Apart from : not mapping regions of the VME bus that you are not using.

The tsi148 mappings have to be on 64k boundaries, so yes, it
happens that sometimes you map a bit more than what you need.
But there's no way to get around that; it's a hardware thing
so we just accept it.

E.
