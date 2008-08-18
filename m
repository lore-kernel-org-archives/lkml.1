Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYHRLpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYHRLpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYHRLpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 07:45:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:46513 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYHRLpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:45:35 -0400
Date: Mon, 18 Aug 2008 04:44:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: tvrtko.ursulin@sophos.com
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Rik van Riel <riel@redhat.com>,
       rmeijer@xs4all.nl, Theodore Tso <tytso@mit.edu>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
 a linux interface for on access scanning (fwd)
In-Reply-To: <20080818103126.3461C2FE848@pmx1.sophos.com>
Message-ID: <alpine.DEB.1.10.0808180441560.12859@asgard.lang.hm>
References: <20080818103126.3461C2FE848@pmx1.sophos.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, tvrtko.ursulin@sophos.com wrote:

> David Lang wrote on 18/08/2008 02:25:44:
>
>> what is not covered by this design that is covered by the threat model
> being
>> proposed?
>>
>> what did I over complicate in this design? or is it the minimum feature
> set
>> needed?
>>
>> are any of the features I list impossible to implement?
>
> One more thing - this proposal does not work where there are no extended
> attributes (whether at all or they are disabled at mount time). I think
> that is a serious flaw or at least disadvantage compared to the posted
> implementation.

good point. I should have listed that.

I don't see it as a serious flaw, people who care about this feature can 
just pick an appropriate filesystem to use.

but if extended attributes are not found a strict implementation could 
fall back to scanning on every file access (the extended attributes are 
being used to cache the results of the scans)

David Lang
