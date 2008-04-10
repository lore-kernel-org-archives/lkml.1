Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYDJIOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYDJIOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYDJIOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:14:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755065AbYDJIOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:14:20 -0400
Date: Thu, 10 Apr 2008 09:10:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: Re: [PATCH 2/3] x86: GEODE: add Virtual Systems Architecture
 detection
Message-ID: <20080410091057.45cbb938@core>
In-Reply-To: <20080409223328.5774d6cf@ephemeral>
References: <20080409223328.5774d6cf@ephemeral>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 22:33:28 -0400
Andres Salomon <dilinger@queued.net> wrote:

> 
> This is generic VSA detection.  It's used by OLPC to determine whether or
> not the BIOS contains VSA, but since other BIOSes are coming out that don't
> use the VSA (ie, tinybios), it might end up being useful for others.

NAK - but minor

This is a check for *VSA2* which is not the same as VSA1 (Cyrix one) and
for older systems that actually matters as you may have VSA1 or VSA2 and
they are detected differently.

> +/* VSA magic values */

These should be VSA2 I think

> +static inline int geode_has_vsa(void)

has_vsa2


Alan (Keeper of the ancient cyrix docs ;))
