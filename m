Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbXGILkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbXGILkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXGILj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:39:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20721 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGILjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hlClRc+EfkUaxE/TWbpZxIUwhwZR7+W92I9LKGFszTPaQXMvB/bijk6oonqLjo8PghSbjEwZbUWTvC56GUaTCyrMJn6QX8Vl+t9a7AH6iQSBBl85WxXqk9wZGwbsUtnL9q/xNdihRzVQmA2QJR6g4v0fQVaYjxNQSyfo7hfKuXw=
Message-ID: <46921E87.8000309@googlemail.com>
Date: Mon, 09 Jul 2007 13:39:51 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravenborg.org
Subject: Re: [PATCH] fixup binutils printing from scripts/ver_linux
References: <200707090147.58611.jesper.juhl@gmail.com> <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com> <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 9 2007 04:39, Gabriel C wrote:
>   
>>> NAK. It starts reporting here empty binutils field.
>>> FWIW,
>>>
>>>  $ ld -v
>>>  GNU ld version 2.16.1
>>>
>>>       
>> Well the format changed so now we have :
>>
>> $ ld -v
>> GNU ld (Linux/GNU Binutils) 2.17.50.0.16.20070511
>>     
>
> Adding to the collection:
> 12:39 ichi:~ > ld -v
> GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)
>
>
>   

Uhh :) Ok here an ugly one :

$ ld -v | sed 's/.*version//;s/.*Binutils)//'|awk '{print $1}'|tr -d ' '
2.17.50.0.16.20070511

$ echo 'GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)' | sed 
's/.*version//;s/.*Binutils)//'|awk '{print $1}'|tr -d ' '
2.17.50.0.5

$ echo 'GNU ld version 2.16.1' | sed 's/.*version//;s/.*Binutils)//'|awk 
'{print $1}'|tr -d ' '
2.16.1


Gabriel
