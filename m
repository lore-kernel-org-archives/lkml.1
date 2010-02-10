Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0BJVeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:34:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab0BJVek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:34:40 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: Rik van Riel <riel@redhat.com>
Subject: Re: Improving OOM killer
Date: Wed, 10 Feb 2010 22:34:38 +0100
User-Agent: KMail/1.9.10
Cc: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <201002102154.39771.l.lunak@suse.cz> <4B73206C.8090108@redhat.com>
In-Reply-To: <4B73206C.8090108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002102234.38377.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of February 2010, Rik van Riel wrote:
> On 02/10/2010 03:54 PM, Lubos Lunak wrote:
> >   Simply computing the cost of the whole children subtree (or a
> > reasonable approximation) avoids the need for any magic numbers and gives
> > a much better representation of how costly the subtree is, since, well,
> > it is the cost itself.
>
> That assumes you want to kill off that entire tree.

 As said in another mail, I think I actually do, since the entire tree is 
indentified as the problem. But regardless of that, surely computing the cost 
of a forkbomb by computing something that is close to the actual cost of it 
is better than trying magic numbers?

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
