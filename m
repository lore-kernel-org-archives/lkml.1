Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbYHEDJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbYHEDJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYHEDHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:07:21 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:49949
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYHEDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:07:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAHRgl0jLO4pc/2dsb2JhbAAIimCkfA
X-IronPort-AV: E=Sophos;i="4.31,307,1215360000"; 
   d="scan'208";a="365709780"
Message-ID: <4897C2A7.7020601@ii.net>
Date: Tue, 05 Aug 2008 11:01:59 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <4897BFB4.9090309@schaufler-ca.com>
In-Reply-To: <4897BFB4.9090309@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we had stackable LSMs then the required functionality could simply be 
built into the LSM interface. Then the anti-malware would simply stack 
itself with other LSMs. In my opinion this is a perfect example for the 
argument of stackable LSMs. So far we mainly have LSMs which provide an 
extra access control mechanism (in addition to DAC). IMHO, Ideally DAC 
could be another stackable LSM (enabled by default). Other security 
schemes such as intrusion detection, firewalls/netfilter, anti-malware, 
and application restrictions (sandboxes such as jails or finer grained 
restrictions such as AppArmor) could all register LSMs onto the stack.

Additional infrastructure would be necessary. Permissible security 
remains a item of contention. Perhaps I am naive but I think most LSMs 
could work based on accept/reject. Where every LSM must accept an action 
in order for it to be carried out.

MHO,

Cliffe.

Casey Schaufler wrote:
> Eric Paris wrote:
>> Please contact me privately or (preferably the list) for questions,
>> comments, discussions, flames, names, or anything.  I'll do complete
>> rewrites of the patches if someone tells me how they don't meet their
>> needs or how they can be done better.  I'm here to try to bridge the
>> needs (and wants) of the anti-malware vendors with the technical
>> realities of the kernel.  So everyone feel free to throw in your two
>> cents and I'll try to reconcile it all.  These 5 patches are part 1.
>> They give us a working able solution.
>>
>> >From my point of view patches forthcoming and mentioned below should
>> help with performance for those who actually have userspace scanners but
>> also could presents be implemented using this framework.
>>
>>   
>
> The LSM list (CCed) should be included in this discussion.
>> Background
>> ...
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
