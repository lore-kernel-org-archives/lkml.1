Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbYBCN0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbYBCN0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYBCNZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:25:54 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63867 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbYBCNZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:25:53 -0500
Date: Sun, 3 Feb 2008 14:25:06 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       dhowells@redhat.com, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/4] AVR32: cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <20080203142506.2003e5cf@siona>
In-Reply-To: <47a5a660.19e7300a.0584.329a@mx.google.com>
References: <20080203112217.126814108@gmail.com>
	<47a5a660.19e7300a.0584.329a@mx.google.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed bogus @atmel.co address from Cc]

On Sun, 03 Feb 2008 14:22:18 +0300
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Applied, thanks.

I found myself having to grep through include/linux to figure out what
this _AC macro was really all about, so I added this to the description:

    PAGE_SIZE is used both from assembly and C code. We want to have type
    specifiers when using it from C, but this will make the assembler
    confused, so we need to make it conditional.
    
    This is exactly what the _AC macro is for, so using it allows us to
    get rid of a few lines of cpp noise.

My first thought was "Autoconf", and it sent shivers down my spine ;-)

Haavard
