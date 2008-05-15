Return-Path: <linux-kernel-owner+w=401wt.eu-S1763837AbYEOVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763837AbYEOVNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYEOVNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:13:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54406 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbYEOVNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:13:46 -0400
Date: Thu, 15 May 2008 22:02:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tcamuso@redhat.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
Subject: Re: [PATCH] PCI: Correct last two HP entries in the bfsort
 whitelist
Message-ID: <20080515220215.76eea915@core>
In-Reply-To: <482C838E.3030203@redhat.com>
References: <482C838E.3030203@redhat.com>
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

On Thu, 15 May 2008 14:40:14 -0400
Tony Camuso <tcamuso@redhat.com> wrote:

> Greetings.
> 
> There is a code flaw in the bfsort whitelist, where there are redundant
> entries for the same two HP systems, DL385 G2 and DL585 G2. This patch
> replaces those redundant entries with the correct ones. The correct
> entries are for large-volume systems, the DL360 and DL380.

This is going to make everyone with those boxes who upgrades suddenely
get their devices re-ordered and renamed when the probe order changes.
That seems extremely inappropriate.

Alan
