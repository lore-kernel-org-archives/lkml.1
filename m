Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYFRRg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYFRRg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYFRRgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:36:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41251 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbYFRRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:36:47 -0400
Date: Wed, 18 Jun 2008 18:18:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: linux-kernel@vger.kernel.org, 486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080618181856.3474859d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080618101402.GF15718@soziologie.ch>
References: <20080618101402.GF15718@soziologie.ch>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 12:14:02 +0200
Gaudenz Steinlin <gaudenz@debian.org> wrote:

> Hi
> 
> The kernel modules for Mac on Linux (MOL) need handle_mm_fault. 
> MOL is a GPL licensed virtual machine to run MacOS(X) on PPC Linux.
> 
> The export for handle_mm_fault was removed with commit
> 41f9dc5c871600f53c8912b2975971d2a11c1c25. 

This sort of thing is going to happen if modules hide out of tree. If MOL
is GPL why isn't it getting submitted to the kernel tree - other
virtualisation subsystems such as KVM are in tree ?
