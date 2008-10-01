Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYJAKeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYJAKeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYJAKeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:34:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46202 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752185AbYJAKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:34:04 -0400
Date: Wed, 1 Oct 2008 11:33:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
 uninitialized
Message-ID: <20081001113343.4bf25ea5@lxorguk.ukuu.org.uk>
In-Reply-To: <20081001080150.GC25832@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
	<1222847847-7127-2-git-send-email-steven@uplinklabs.net>
	<1222847847-7127-3-git-send-email-steven@uplinklabs.net>
	<20081001080150.GC25832@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 10:01:50 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> ( Alan Cc:-ed. Seems like gcc bogosity - so your solution of using
>   uninitialized_var() is the correct way to annotate this. )

Sorry but uninitialized_var() is too ugly to be acceptable. Please use a
proper __foo style notation for consistency with the rest of the kernel

(Besides which last time I checked current gcc could figure that one out)

Alan
