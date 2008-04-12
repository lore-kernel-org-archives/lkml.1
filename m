Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbYDLM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbYDLM0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760210AbYDLMZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:25:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760112AbYDLMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:25:50 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20080411210022.GJ11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 14:24:41 +0200
Message-Id: <1208003081.7427.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 15:00 -0600, Matthew Wilcox wrote:

> So does it make sense to retain the completion as a primitive
> in Linux? 

My take on it is the opposite: kill off semaphores and leave the
completions around.

