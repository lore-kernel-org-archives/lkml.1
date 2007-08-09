Return-Path: <linux-kernel-owner+w=401wt.eu-S965773AbXHIPDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbXHIPDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965561AbXHIPDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:03:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518AbXHIPDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:03:19 -0400
Message-ID: <46BB2C8E.2050205@redhat.com>
Date: Thu, 09 Aug 2007 11:02:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Lionel Elie Mamane <lionel@mamane.lu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingcha@pimp.vs19.net
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <20070804163733.GA31001@elte.hu> <20070809062511.GA23435@capsaicin.mamane.lu>
In-Reply-To: <20070809062511.GA23435@capsaicin.mamane.lu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2007 02:25 AM, Lionel Elie Mamane wrote:
> 
>> yeah, it's really ugly. But otherwise i've got no real complaint
>> about ext3 - with the obligatory qualification that
>> "noatime,nodiratime" in /etc/fstab is a must. This speeds up things
>> very visibly (...). So for most file workloads we give Windows a
>> 20%-30% performance edge, for almost nothing.
> 
> It has been years since I used MS Windows much, but from my memories
> of my these days, I was under the impression that it (at least the NT
> line, the only surviving line these days) also maintained "last
> accessed" times. Except I only ever saw it at "right now" because the
> file explorer ... accesses the file before getting this metadata or
> something like that (when you right-click on a file and ask for its
> properties). It has creation and last modification time, too.
> 

NT maintains atimes by default, at least up to XP. You have to edit the
registry to turn them off, and it is a single global switch -- not per
mountpoint like Unix.

And it makes a huge difference there, too.
