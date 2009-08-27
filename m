Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZH0Tez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZH0Tez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZH0Tey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:34:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbZH0Tey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:34:54 -0400
Date: Thu, 27 Aug 2009 12:34:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Anirban Sinha <ASinha@zeugmasystems.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] console_print: change the function api to make it have
 printk style interface
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local>
Message-ID: <alpine.LFD.2.01.0908271233580.3218@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <20090825172640.af8b9f58.randy.dunlap@oracle.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Anirban Sinha wrote:
> 
> Since Linus has already agreed for the later, I will post a patch here
> to remove the function. I am not very certain as to what we should do
> about the only one single case of its genuine use - call from
> ia64/head.S. What I have done is one solution. Please feel free to
> debate/disagree.

Looks ok to me, but I'm not going to apply it in late -rc, since it 
doesn't really fix any bug. Feel free to re-send after 2.6.31 is out, or 
try to get it into one of the trees to be merged later.

		Linus
