Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbYBFXLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbYBFXLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763612AbYBFXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:06:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763593AbYBFXGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:06:54 -0500
Date: Wed, 6 Feb 2008 15:06:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harald Arnesen <skogtun.linux@gmail.com>
cc: linux-kernel@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>
Subject: Re: Latest git oopses during boot
In-Reply-To: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802061501390.2883@woody.linux-foundation.org>
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Feb 2008, Harald Arnesen wrote:
>
> Photo of screen attached (no serial terminal, and alas, no decent
> tripod either).

To make that oops even remotely useful, you do need at least 
CONFIG_DEBUG_BUGVERBOSE enabled, and really preferably also 
CONFIG_KALLSYMS.

Otherwise there is no symbolic debug info, and it's impossible to even 
really guess what is going on.

It seems to happen early on module load (which is good, that makes it 
likely easier to debug), but without knowing the function and call chain, 
it's a bit useless. 

		Linus
