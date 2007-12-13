Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbXLMW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbXLMW3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766000AbXLMW3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:29:11 -0500
Received: from ns.suse.de ([195.135.220.2]:41895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765706AbXLMW3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:29:09 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
From: Andi Kleen <andi@firstfloor.org>
References: <20071213222044.GH21616@stusta.de>
Date: Thu, 13 Dec 2007 23:29:08 +0100
In-Reply-To: <20071213222044.GH21616@stusta.de> (Adrian Bunk's message of "Thu\, 13 Dec 2007 23\:20\:44 +0100")
Message-ID: <p73bq8ugrez.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:
>
> -rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
> -rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux

File sizes are useless -- check size output.

> It's not a surprise that the kernel can become bigger when __read_mostly 
> gets used, especially in cases where __read_mostly prevents gcc 
> optimizations.

What optimizations do you think it prevents?  I don't think it 
should change the gcc generated code at all; the only difference
should be to the linker.

-Andi

