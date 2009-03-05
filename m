Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZCETYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZCETYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZCETYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:24:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:44570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbZCETYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:24:19 -0500
Message-ID: <49B02692.3000500@kernel.org>
Date: Thu, 05 Mar 2009 11:22:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
References: <49AF18B7.4050305@kernel.org>	 <tip-a1aade478862fca8710904532cbc6efed97fd05a@git.kernel.org> <1236267366.5937.56.camel@desktop>
In-Reply-To: <1236267366.5937.56.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2009-03-05 at 10:00 +0000, Yinghai Lu wrote:
> 
>> +
>> +Mini-HOWTO for using the earlyprintk=dbgp boot option with a
>> +USB2 Debug port key and a debug cable, on x86 systems.
>> +
>> +You need two computers, the 'USB debug key' special gadget and
>> +and two USB cables, connected like this:
>> +
>> +  [host/target] <-------> [USB debug key] <-------> [client/console]
>> +
>> +1. There are three specific hardware requirements:
>> +
>> + a.) Host/target system needs to have USB debug port capability.
>> +
>> + You can check this capability by looking at a 'Debug port' bit in
>> + the lspci -vvv output:
> 
> ...
> 
>> + c.) Thirdly, you need a second client/console system with a regular USB port.
> 
> You might want to combine a.) and c.) since there is some disconnect
> between the two. c.) doesn't explicitly say a second time that the
> client/console needs the debug port capability ..
> 
> Or say
> 
> a.) You will need two USB ports. One on the client/console system and
> one one the target system.
> 
> b.) The client/console and target USB ports must have the debug port
> capability. You can check for this as follows,
> 
> c.) ...

thanks for checking it.

can you submit patch to Ingo according to tip/master?

YH
