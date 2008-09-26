Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYIZIUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYIZIUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYIZIT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:19:56 -0400
Received: from mail.collax.com ([82.194.105.242]:45951 "EHLO
	collgate4.collax.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbYIZITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:19:54 -0400
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Message-Id: <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com>
From: Tilman Baumann <tilman.baumann@collax.com>
To: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <48DC5A45.8020801@schaufler-ca.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: SMACK netfilter smacklabel socket match
Date: Fri, 26 Sep 2008 10:19:40 +0200
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com>
X-Mailer: Apple Mail (2.929.2)
X-Filtered: By ProxSMTP
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2008 um 05:43 schrieb Casey Schaufler:

> Tilman Baumann wrote:
>> Hi all,
>>
>> i made some SMACK related patches. I hope this list is the right  
>> place to post them.
>
> Here and, probably more importantly linux-security-module@vger.kernel.org 
>  as that's
> my primary hang out.
>
>> The intention behind this patch is that i needed a way to  
>> (firewall) match for packets originating from specific processes.
>> The existing owner match did not work well enough, especially since  
>> the cmd-owner part is removed.
>> Then i thought about a way to tag processes and somehow match this  
>> tag in the firewall.
>> I recalled that SELinux can do this (SECMARK) but SELinux would  
>> have been way to complex for what i want. But the idea was born, i  
>> just needed something more simple.
>>
>> SMACK seemed to be the right way. So i made a little primitive  
>> netfilter match to match against the security context of sockets.
>> SMACK does CIPSO labels, but this was not what i wanted, i wanted  
>> to label the socket not the packet (on the wire).
>> This of course only works for packets with a local socket, but this  
>> was my intention anyway.
>>
>> This way i can label a process and all it's sockets carry the same  
>> label which i then can use to match against in the firewall.
>>
>
> Hmm. It looks as if your code will do what you're asking it to do.
> Are you going to be happy with the access restrictions that will be
> imposed by Smack?

I helped myself with rules like this.
_ foo rwx
But i wanted to add some security stuff like selinux for years,
and SMACK seems to be just great.
So i will spend some time making security rules after i got this routing
stuff to work. :)

Regards
  Tilman
