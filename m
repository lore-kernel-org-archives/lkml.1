Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYHUJ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYHUJ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYHUJ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:29:20 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61631 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751595AbYHUJ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:29:19 -0400
Date: Thu, 21 Aug 2008 10:27:57 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
In-Reply-To: <200808202356.33036.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
References: <200808202106.41058.elendil@planet.nl> <200808202138.13302.rjw@sisk.pl>
 <200808202226.45655.elendil@planet.nl> <200808202356.33036.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Rafael J. Wysocki wrote:

> On my box I see many "APIC error on CPU1: 00(40)" messages that don't seem
> to be related to anything obviously bad and I've alwas been seeing them.

 Barring a hardware erratum, this is a bug in the kernel.  It should be
moderately easy to track down with some debugging added to writes
accessing LVT and redirection table entries.

  Maciej
