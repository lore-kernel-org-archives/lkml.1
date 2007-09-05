Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbXIEQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbXIEQly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXIEQlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:41:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1775 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXIEQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:41:46 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
In-Reply-To: <200709051443.21522.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 09:29:08 -0700
Message-Id: <1189009748.4442.19.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 14:43 +0100, Denys Vlasenko wrote:
> Build system: section garbage collection for vmlinux
> 
> 
> Newer gcc and binutils can do dead code and data removal
> at link time. It is achieved using combination of
> -ffunction-sections -fdata-sections options for gcc and
> --gc-sections for ld.
> 
> Theory of operation:
> 
> Option -ffunction-sections instructs gcc to place each function
> (including static ones) in it's own section named .text.function_name
> instead of placing all functions in one big .text section.
> 
> At link time, ld normally coalesce all such sections into one
> output section .text again. It is achieved by having *(.text.*) spec
> along with *(.text) spec in built-in linker scripts.

You version doesn't work with CONFIG_MODULES right?

Also, why do you need this patch,

[PATCH 1/3] build system: section garbage collection for vmlinux

Daniel

