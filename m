Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbXLGWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbXLGWRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbXLGWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:17:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:33946 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbXLGWRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:17:16 -0500
Cc: Olof Johansson <olof@lixom.net>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <9AEDD952-7F20-471C-9A82-B6F3254BC869@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: balbir@linux.vnet.ibm.com
In-Reply-To: <4759C548.6030304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Date: Fri, 7 Dec 2007 16:15:54 -0600
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com> <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org> <4759C548.6030304@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 7, 2007, at 4:12 PM, Balbir Singh wrote:

> Kumar Gala wrote:
>>
>> On Dec 7, 2007, at 3:35 PM, Balbir Singh wrote:
>>
>>> Olof Johansson wrote:
>>>> Hi,
>>>>
>>>> On Sat, Dec 08, 2007 at 02:44:25AM +0530, Balbir Singh wrote:
>>>>
>>>>> Comments are as always welcome!
>>>>
>>>> Care to explain what this is useful for? (Not saying it's a  
>>>> stupid idea,
>>>> just wondering what the reason for doing it is).
>>>>
>>>
>>> In my case, I use it to test parts of my memory controller patches  
>>> on an
>>> emulated NUMA machine. I plan to use it to test out page migration
>>> across nodes.
>>
>> Can you explain that further.  I'm still not clear on why this is  
>> useful.
>>
>> - k
>
> Sure. In my case I need to emulate NUMA nodes to do some NUMA specific
> testing. The memory controller I've written has some interesting data
> structures like per node, per zone LRU lists. To be able to test those
> features on a non-numa box is a problem, since we get just the  
> default node.

Maybe I'm missing something, what do you mean by memory controller  
you've written?  (I'm use to the term 'memory controller' meaning the  
actual RAM control).

> To be able to test the memory controller under NUMA, I use fake NUMA
> nodes. x86-64 has a similar feature, the code I have here is the
> simplest I could come up with for PowerPC.
>
> I just thought of another very interesting use case, it can be used to
> split up the zone's lru lock which is highly contended.

- k
