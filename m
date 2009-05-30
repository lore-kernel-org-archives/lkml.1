Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZE3WaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZE3WaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZE3WaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:30:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbZE3WaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:30:05 -0400
Date: Sat, 30 May 2009 15:29:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: linux-mm@kvack.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
In-Reply-To: <20090530192829.GK6535@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 May 2009, Larry H. wrote:
> 
> The ZERO_OR_NULL_PTR macro is changed accordingly. This patch does
> not modify its behavior nor has any performance nor functionality
> impact.

I'm sure it makes a code generation difference, with (a) big constants and 
(b) no longer possible to merge the conditional into one single one.

		Linus
