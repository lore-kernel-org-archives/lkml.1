Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbZJNTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbZJNTQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZJNTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:16:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54865 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbZJNTQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:16:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AD6235B.8090905@s5r6.in-berlin.de>
Date: Wed, 14 Oct 2009 21:15:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to check whether executing in atomic context?
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>	 <20091014101336.GA25108@redhat.com>	 <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>	 <4AD60CD1.4000804@s5r6.in-berlin.de> <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com>
In-Reply-To: <f22d86810910141211u1f83f57fibfaa5ee19a39813f@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leonidas . wrote:
> On Wed, Oct 14, 2009 at 11:09 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> let the caller of your routine tell it whether it's atomic context
>> or not.
[...]
> What makes it more complicated is this, the user might achieve the
> functionality via instrumenting his source code, i.e. something like
> using -finstrument flag of gcc. As per above inferences about
> in_atomic(), in case of instrumentation there is no choice other than
> providing all apis as atomic apis, this might not be the right thing
> to do under all circumstances. Especially, for my code since I do lot
> of allocations for book keeping.
> 
> I am not aware of any Linux kernel module which can comply to this
> kind of use case, what would be the most optimal thing to do here?

And preallocation is not feasible either?
-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/
