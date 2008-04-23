Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYDWLRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYDWLRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYDWLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:17:26 -0400
Received: from h155.mvista.com ([63.81.120.155]:48365 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbYDWLRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:17:25 -0400
Message-ID: <480F1A9E.6080003@ru.mvista.com>
Date: Wed, 23 Apr 2008 15:16:46 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca> <480DFE76.8000809@ru.mvista.com> <480E345D.9090406@ru.mvista.com> <480E9C15.6080103@gmail.com> <480EB930.1040308@garzik.org>
In-Reply-To: <480EB930.1040308@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>> Aik... We can do s/sff/tf/ and leave bmdma alone to avoid even more 
>> confusion but sff has meant tf base interface for quite some time now 
>> in libata and I think it'll be better to remember that sff is the new 
>> tf. Sorry about the mess.

> This renaming was discussed at the time on lkml and linux-ide, the 
> patches and git pushes were CC'd, and I do not recall these complaints 
> being raised at the time.

    I wasn't watching libata activity even to such a small extent that I'm 
doing it now, and I haven't found the discussion now.

> At this point, it's too ingrained in libata.  Another rename would IMO 
> just cause more needless churn.

    Well, renaming -bmdma to -sff was logical.  What's not so logical is that 
module covering not only BMDMA activities but also taskfile access.

>     Jeff

MBR, Sergei
