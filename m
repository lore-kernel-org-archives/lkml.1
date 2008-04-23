Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYDWCTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYDWCTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 22:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbYDWCSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 22:18:45 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:43566 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYDWCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 22:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YGmPmdCK2lKGKrEILQLqd5YvM7rqLbqL5p1WPINfZsD1m6jvay+Giq871CtQy998O+tbZUbV3x1LxhnPMfTvCs1ZwwnRvUykRyzfuEBN44MQnFqWTKcky2ScO6EgV+I77OZ5yxnF4MpbmIpqE25K02yvz2D03D2kXjxQhPFiAw8=
Message-ID: <480E9C15.6080103@gmail.com>
Date: Wed, 23 Apr 2008 11:16:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca> <480DFE76.8000809@ru.mvista.com> <480E345D.9090406@ru.mvista.com>
In-Reply-To: <480E345D.9090406@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello, I wrote:
> 
>>> I suppose.   If we were needlessly pedantic, then perhaps
>>> the libata-bmdma.c should be renamed to libata-sff.c,
> 
>    It *was* renamed to libata-sff.c, back in 2006. :-)
> 
>>> and the libata-sff.c should be renamed libata-tf.c
> 
>    Not before splitting SFF-8038i stuff from it.
> 
>>> But there's probably been a document or two since then,
>>> where the SFF folks have documented the TF interfaces, too.
> 
>>    Don't know, at least I haven't encountered such spec. Unless you 
>> mean SFF-8020i (ATAPI CD-ROM spec).
> 
>    I've looked thru the list of their spec. and it didn't seem to have 
> any about taskfile specifically. SFF-8070 (ATAPI CD-RW) refers to 
> ATA/PI-4 for that matter.

Aik... We can do s/sff/tf/ and leave bmdma alone to avoid even more 
confusion but sff has meant tf base interface for quite some time now in 
libata and I think it'll be better to remember that sff is the new tf. 
Sorry about the mess.

Thanks.

-- 
tejun
