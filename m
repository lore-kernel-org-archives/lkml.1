Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752912AbYLRSj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYLRSj2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYLRSjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:39:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:57601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYLRSjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:39:17 -0500
Subject: Re: [PATCH] x86: process.c declare c1e_remove_cpu before they get
	used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20081218123613.GE25715@elte.hu>
References: <1229536205.23068.6.camel@jaswinder.satnam>
	 <20081218123613.GE25715@elte.hu>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 00:07:39 +0530
Message-Id: <1229625459.3197.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 13:36 +0100, Ingo Molnar wrote:

> hm, why is this needed? Have you seen a compiler warning?
> 

I was getting :

  CHECK   arch/x86/kernel/process.c
arch/x86/kernel/process.c:284:6: warning: symbol 'c1e_remove_cpu' was not declared. Should it be static?

Thank you,

Jaswinder Singh.

