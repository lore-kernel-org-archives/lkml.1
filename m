Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0BJV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:29:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:48908 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0BJV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:29:26 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: Rik van Riel <riel@redhat.com>
Subject: Re: Improving OOM killer
Date: Wed, 10 Feb 2010 22:29:24 +0100
User-Agent: KMail/1.9.10
Cc: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <201002102154.43231.l.lunak@suse.cz> <4B7320BF.2020800@redhat.com>
In-Reply-To: <4B7320BF.2020800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002102229.24448.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of February 2010, Rik van Riel wrote:
> On 02/10/2010 03:54 PM, Lubos Lunak wrote:
> >   Which however can mean that not killing this system daemon will be
> > traded for DoS-ing the whole system, if the daemon keeps spawning new
> > children as soon as the OOM killer frees up resources for them.
>
> Killing the system daemon *is* a DoS.

 Maybe, but if there are two such system daemons on the machine, it's only 
half of the other DoS. And since that system daemon has already been 
identified as a forkbomb, it's probably already useless anyway and killing 
the children won't save anything. In which realistic case a system daemon has 
children that together cause OOM, yet can still be considered working after 
you kill one or a limited number of those children?

> It would stop eg. the database or the web server, which is
> generally the main task of systems that run a database or
> a web server.

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
