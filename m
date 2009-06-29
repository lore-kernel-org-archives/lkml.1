Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZF2Kj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZF2Kj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZF2Kjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:39:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45665 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbZF2Kjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:39:48 -0400
Subject: Re: kmemleak hexdump proposal
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1246270774.6364.9.camel@penberg-laptop>
References: <20090628173632.GA3890@localdomain.by>
	 <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
	 <20090629101917.GA3093@localdomain.by>
	 <1246270774.6364.9.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 29 Jun 2009 11:38:00 +0100
Message-Id: <1246271880.21450.13.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 10:38:01.0114 (UTC) FILETIME=[ACEAEFA0:01C9F8A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 13:19 +0300, Pekka Enberg wrote:
> On Mon, 2009-06-29 at 13:19 +0300, Sergey Senozhatsky wrote:
> > Well, it's not easy to come up with something strong. 
> > I agree, that stack gives you almost all you need.
> > 
> > HEX dump can give you a _tip_ in case you're not sure. 
> 
> Don't get me wrong, I'm not against it in any way. If Catalin is
> interested in merging this kind of functionality, go for it! You might
> want to consider unconditionally enabling the hexdump. If the
> information is valuable, we should print it all the time.

Though I prefer to do as much as possible in user space, I think this
feature would be useful.

Anyway, I may not include it before the next merging window (when is
actually the best time for new features). Currently, my main focus is on
reducing the false positives.

-- 
Catalin

