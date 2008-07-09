Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYGII7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYGII7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYGII7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:59:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:33020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbYGII7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:59:06 -0400
Subject: Re: AZFS file system proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Maxim Shchetynin <maxim@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807011659.33413.arnd@arndb.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	 <200807011659.33413.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 18:58:38 +1000
Message-Id: <1215593918.8970.363.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 16:59 +0200, Arnd Bergmann wrote:
> I wouldn't hold up merging the file system for this problem, but
> until it is solved, the Kconfig entry should probably have
> a "depends on PPC".

Better, use an ifdef for powerpc flags, and #else to pgprot_noncached.

Ben.


