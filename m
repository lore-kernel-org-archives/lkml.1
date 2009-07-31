Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZGaM5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZGaM5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZGaM5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:57:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZGaM5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:57:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200907311227.20132.elendil@planet.nl>
References: <200907311227.20132.elendil@planet.nl>
To: Frans Pop <elendil@planet.nl>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: RomFS: enless loop during make oldconfig from 2.6.24 -> 2.6.31-rc4 (parisc)
Date: Fri, 31 Jul 2009 13:57:34 +0100
Message-ID: <17615.1249045054@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> wrote:

> Near the end of the 'make oldconfig' I got into an endless loop. I never
> even got a chance to make a choice, it just continued looping on the
> display.

It works fine for me, using a GNUmakefile with:

	CROSS_COMPILE	:= hppa-linux-
	ARCH		:= parisc

set.  I used whatever was latest from Linus's tree.  I did just hold enter
down to select all the defaults.

David
