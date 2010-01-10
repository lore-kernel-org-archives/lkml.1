Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091Ab0AJDJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0AJDJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 22:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242Ab0AJDJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 22:09:51 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40396 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0AJDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 22:09:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B1cxcz1rC8l7UBbK5vm6nZ9kd+Rwn0nQcaMBt4pAaSIAXG3qk7Vf3p7buwieSuw/m2
         /fewxRqRLDOmXjlMFL1JB0bpOGOLvdBRrJm85CnUZ8dj7KDf7sRk5WjNG/a9saEKAP9B
         xgbO8otkHl7a2JS5g3d7E7fq+zdRzdgUXe9/I=
Message-ID: <4B4944FB.4040008@gmail.com>
Date: Sat, 09 Jan 2010 21:09:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Dimitrios Apostolou <jimis@gmx.net>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
    (fwd)
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> 	<20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> 	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> 	<20100109160836.26a344a9@infradead.org> <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> 	<20100109164240.43b21247@infradead.org> <2c0942db1001091807k542b1052s96111775d6431bd0@mail.gmail.com>
In-Reply-To: <2c0942db1001091807k542b1052s96111775d6431bd0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2010 08:07 PM, Ray Lee wrote:
> On Sat, Jan 9, 2010 at 4:42 PM, Arjan van de Ven<arjan@infradead.org>  wrote:
>> basically it appears that your machine, when the kernel asks for C2,
>> exits C2 immediately again.
>>
>> The old algorithm somehow caught this and stopped asking for C2 most of
>> the time; the new algorithm doesn't see any activity and asks for C2
>> again.
>
> This change of behavior will certainly bite more users out there. Is
> there any way we can detect the systems that aren't honoring the C2
> request and limit back to C1?

That seems like it would be a better approach, rather than adding to a 
DMI list which is almost certainly incomplete.. We've got too many DMI 
special cases in the kernel already.
