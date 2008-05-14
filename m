Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYENVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYENVsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYENVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:48:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33562 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbYENVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:48:14 -0400
Date: Wed, 14 May 2008 22:37:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix atomic_t overflow in vm
Message-ID: <20080514223726.6e09f049@core>
In-Reply-To: <20080514213302.5631.54560.stgit@core>
References: <20080514213302.5631.54560.stgit@core>
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

On Wed, 14 May 2008 22:33:03 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@redhat.com>
> 
> The atomic_t type is 32bit but a 64bit system can have more than 2^32
> pages of virtual address space available. Without this we overflow on
> ludicrously large mappings
> ---

Umm need to adjust the template: Add

Signed-off-by: Alan Cox <alan@redhat.com>
