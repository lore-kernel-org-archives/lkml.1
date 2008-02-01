Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYBAGHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYBAGHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYBAGHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:07:21 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33692 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYBAGHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:07:19 -0500
Message-ID: <47A2B71A.4090203@davidnewall.com>
Date: Fri, 01 Feb 2008 16:37:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kaber@trash.net, kadlec@blackhole.kfki.hu, jeff.chua.linux@gmail.com,
       linux-kernel@vger.kernel.org, ole@ans.pl, cups-bugs@easysw.com,
       netfilter-devel@vger.kernel.org
Subject: Re: cups slow on linux-2.6.24
References: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>	<47A21945.2050005@trash.net>	<47A26C12.9020801@davidnewall.com> <20080131.181209.193710785.davem@davemloft.net>
In-Reply-To: <20080131.181209.193710785.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Newall <davidn@davidnewall.com>
> Date: Fri, 01 Feb 2008 11:17:14 +1030
>
>   
>> Patrick McHardy wrote:
>>     
>>> Jozsef Kadlecsik wrote:
>>>       
>>>> Strange, but there are a lot of incorrect checksum packets. How does
>>>> it come on the loopback interface?
>>>>         
>>> Loopback doesn't perform full checksumming, so thats expected.
>>>       
>> The question remains: How do loopback packets get incorrect checksum? 
>> Where and how can they get corrupted?
>>     
>
> There are zeros there, which is an incorrect checksum most
> of the time.
>   

I'm not debating that checksums are wrong. The question was how and
where? It's not as if there are any unreliable communication paths in a
loopback interface, so it's surprising that they could be wrong. How? Where?
