Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZFLMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZFLMGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZFLMGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:06:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:43320 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbZFLMGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:06:39 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git head build failure
References: <20090612130352.3bddfaaf@lxorguk.ukuu.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Jun 2009 13:06:26 +0100
In-Reply-To: <20090612130352.3bddfaaf@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri\, 12 Jun 2009 13\:03\:52 +0100")
Message-ID: <tnxljnxu059.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2009 12:06:35.0256 (UTC) FILETIME=[3B5EE780:01C9EB56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> mm/built-in.o: In function `kmemleak_scan':
> /usr/src/LINUS/2.6/GIT/Next/linux-ttydev/mm/kmemleak.c:981: undefined
> reference to `_sdata'
>
> x86-64. .config on request

You need this patch as well (it's being pushed via x86/urgent):

http://www.linux-arm.org/git?p=linux-2.6.git;a=commitdiff_plain;h=111cfd004dfbd872ce04d92cc8cfce81d579e337

-- 
Catalin
