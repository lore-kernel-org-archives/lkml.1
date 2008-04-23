Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYDWNai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYDWNai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYDWNa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:30:28 -0400
Received: from rtr.ca ([76.10.145.34]:2097 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYDWNa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:30:27 -0400
Message-ID: <480F39F0.7050207@rtr.ca>
Date: Wed, 23 Apr 2008 09:30:24 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca> <480DFE76.8000809@ru.mvista.com> <480E345D.9090406@ru.mvista.com> <480E9C15.6080103@gmail.com> <480EB930.1040308@garzik.org>
In-Reply-To: <480EB930.1040308@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Aik... We can do s/sff/tf/ and leave bmdma alone to avoid even more 
>> confusion but sff has meant tf base interface for quite some time now 
>> in libata and I think it'll be better to remember that sff is the new 
>> tf. Sorry about the mess.
> 
> 
> This renaming was discussed at the time on lkml and linux-ide, the 
> patches and git pushes were CC'd, and I do not recall these complaints 
> being raised at the time.
> 
> At this point, it's too ingrained in libata.  Another rename would IMO 
> just cause more needless churn.
..

I heartily agree.

Besides, we all seem to understand that -sff means the register level
programming interface for ATA, with and without the old style bmdma.

As opposed to some funky modern host queue style of interface.

It's as good a split as any.

cheers
