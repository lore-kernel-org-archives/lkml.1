Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZGYQdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZGYQdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZGYQdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:33:44 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:56553 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbZGYQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:33:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Date: Sat, 25 Jul 2009 18:33:40 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com> <200907090328.53643.elendil@planet.nl>
In-Reply-To: <200907090328.53643.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251833.42598.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 16:33:43.0303 (UTC) FILETIME=[AC980970:01CA0D45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009, Frans Pop wrote:
> > However we shall endeavour to fix this issues as it may be systemic
> > of something else going wrong in the new PAT/AGP code.
>
> Great. Thanks in advance, I do appreciate it.

Any news on this?

> BTW, today I noticed another regression, but I have not yet looked into
> it deeply. When I suspend I normally see at least some console messages
> from the suspend procedure on the framebuffer console, but with .31-rc2
> I only see a cursor. It does not really affect the suspend/resume.
> Could possibly be related. Will investigate further.

This turned out to be unrelated, and is actually an improvement. It's a 
logical result of a printk patch I submitted (for .32):
http://lkml.org/lkml/2009/7http://lkml.org/lkml/2009/7/6/108/6/108

Cheers,
FJP
