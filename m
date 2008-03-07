Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbYCGTBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbYCGTBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYCGTBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:01:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45837 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYCGTBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:01:03 -0500
Date: Fri, 7 Mar 2008 20:02:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [4/13] Prepare page_alloc for the maskable allocator
Message-ID: <20080307190232.GM7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090714.9493F1B419C@basil.firstfloor.org> <20080307181943.GA14779@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307181943.GA14779@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again - looks too big to inline..
> 
> But for both I do not know where they are used and how often.

For the mask allocator it is not that critical, but for the main
allocator it is on the very very hot page allocation/free path. That is why
I didn't want to out-of-line it.

Note I didn't change it, just moved it.

-Andi

