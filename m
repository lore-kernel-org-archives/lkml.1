Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbXF3BVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbXF3BVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 21:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXF3BV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 21:21:26 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:26142 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751317AbXF3BVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 21:21:25 -0400
X-YMail-OSG: Jm7Nb6IVM1k0cyFYofA6k2qGsyveEhKIovirDrNN1N6fTYxwZ59h6HjyT7PNCCSAAFqbJtb0a8PJBHgkxwbD_Zqn172tLdw_U3s-
Message-ID: <4685B00E.3030700@andrei.myip.org>
Date: Fri, 29 Jun 2007 18:21:18 -0700
From: Florin Andrei <florin@andrei.myip.org>
Reply-To: linux-kernel@vger.kernel.org
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: how to determine if the noexec stack is defined by an application
References: <46856F24.5060407@andrei.myip.org> <1183153758.2894.1.camel@laptopd505.fenrus.org>
In-Reply-To: <1183153758.2894.1.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> But it's running a Web service which is a combination of C code and 
>> Tomcat/Java. I have no clue how to determine which portions specify a 
>> noexec stack and which don't.
> 
> like this:
> 
> $ eu-readelf -l /bin/true  | grep STACK
>   GNU_STACK      0x000000 0x00000000 0x00000000 0x000000 0x000000 RW 0x4

Is Sun Java 1.5 a known exception - as an application that doesn't set a 
noexec stack and reverts to default?

# eu-readelf -l ./java | grep STACK | wc -l
0

But then, this bug report seems to indicate otherwise, if I'm reading it 
correctly:

http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5051381

-- 
Florin Andrei

http://florin.myip.org/
