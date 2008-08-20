Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbYHTRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbYHTRvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYHTRvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:51:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:54188 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYHTRvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:51:25 -0400
Date: Wed, 20 Aug 2008 10:50:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
 linux interface for  for access scanning
In-Reply-To: <1219245321.3389.82.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808201034080.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk>  <1219080504.15566.65.camel@localhost.localdomain>  <20080818182556.13ced58f@lxorguk.ukuu.org.uk> 
 <1219082097.15566.82.camel@localhost.localdomain>  <20080818183540.GA5470@cs.cmu.edu>  <1219085176.15566.100.camel@localhost.localdomain>  <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>  <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
 <1219245321.3389.82.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Eric Paris wrote:

>> He is expecting the scanning software to set the policy
>>    so there is no reason to have a system/distro defined policy
>
> I'm not sure of the definition of this 'policy' but, yes, I think all
> scanners should make their own decisions in their own little bubble.

I realized I need to reply to this part just after hitting send on the 
reply to the rest of it.

part of the policy that needs to be set is when scans do and don't need to 
be done.

you almost never want to have 'scans' take place when scanners access 
files (the HSM restore is the only exception), and there are significant 
performance benifits in exempting other programs as well.

you are saying that the decision of which programs to skip and which ones 
to not skip should be the responsibility of the scanner. I disagree for a 
couple of reasons

1. I don't think that the scanner can really know what program is trying 
to do the access.

2. I think the policy of which files to limit to scanned data and which 
ones to allow access to unscanned data should be a sysadmin decision 
(assisted by the distro), not something set through the scanning software. 
In sort I don't trust Symantec, Macafee, etc to make the correct decisions 
for all the different linux distros out there, or for the different 
scanners to provide sane, consistant interfaces to specify this sort of 
thing. I expect each of them to take the attitude that they know what's 
best, and hard-code the policy with little (if any) allowance for 
exceptions, and that exception list would be managed differently for each 
scanner.

David Lang
