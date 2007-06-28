Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbXF1MM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbXF1MM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbXF1MMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:12:19 -0400
Received: from smtpout.mac.com ([17.250.248.171]:63489 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbXF1MMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:12:19 -0400
In-Reply-To: <87ejjwgytd.fsf@basilikum.skogtun.org>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de> <87ejjwgytd.fsf@basilikum.skogtun.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DBDB2ED7-97C8-4002-BF0A-01FF3F5737F4@mac.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Thu, 28 Jun 2007 08:11:59 -0400
To: Harald Arnesen <harald@skogtun.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, at 06:26:06, Harald Arnesen wrote:
> Adrian Bunk <bunk@stusta.de> writes:
>> Is there any userspace Linux compiler that does not support "long  
>> long"?  If yes, is there any other way to tell that something is a  
>> 64bit int on 32bit architectures?
>
> TenDRA C:
>
> "test.c", line 6: Error:
>   [ISO 6.5.2]: Illegal type specifier, 'long long', assuming 'long'.

I can't even find the docs for their "tcc".  Their "tchk" appears to  
have a "#pragma longlong type allow" or something, so I'd imagine the  
same exists for tcc and would be required to build stuff using kernel  
headers.  On the other hand, their compiler looks so immature that it  
does not appear to be worth spending much time worrying about now.   
When somebody shows up with a solution for that compiler then we can  
look at it at that time.

Cheers,
Kyle Moffett

