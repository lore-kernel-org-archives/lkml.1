Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZCCAVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZCCAVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbZCCAVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:21:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbZCCAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:21:36 -0500
Date: Mon, 2 Mar 2009 16:21:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mainline] menu: fix embedded menu snafu
In-Reply-To: <20090302161602.a4eea5d9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0903021619270.3111@localhost.localdomain>
References: <20090302141406.13d5ef1f.randy.dunlap@oracle.com> <20090302161602.a4eea5d9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Andrew Morton wrote:
> 
> This patch causes weird unintended breakage, methinks.

Damn, you're right. It looked obvious, so I already applied it, but I 
clearly shouldn't have.

The whole "if EMBEDDED" thing is totally wrong, because those config 
options  very much_do_ exist even when non-embedded, it's just that then 
they always take their default valies.

Thanks for noticing.

		Linus
