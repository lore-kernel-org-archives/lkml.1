Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZCSKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZCSKtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZCSKtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:49:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:35284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZCSKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:49:05 -0400
Subject: Re: Microblaze linux support
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: monstr@monstr.eu
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <49C21DF0.10808@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	 <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu>
	 <20090319102142.GA2579@elte.hu>  <49C21DF0.10808@monstr.eu>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 16:17:46 +0530
Message-Id: <1237459666.3127.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 11:26 +0100, Michal Simek wrote:

> you are welcome - I can quickly test and add all changes to git.
> 
> Is it good style separate extern definition and EXPORT_SYMBOL?
> 
> I have three choices?
> 1. keep extern + EXPORT_SYMBOL below  - current style
> 2. move only extern to header file
> 3. move extern and EXPORT_SYMBOL to header.
> 
> What is preferable way?

externs should be in header files

EXPORT_SYMBOL should immediately follow its function/variable should
normally be in source files like : arch/x86/kernel/process.c
and if required can also be defined in header files like:
arch/x86/include/asm/percpu.h

--
JSR

