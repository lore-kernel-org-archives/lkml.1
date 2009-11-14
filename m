Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZKNDGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZKNDGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZKNDGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:06:41 -0500
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:37004 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756662AbZKNDGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:06:40 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: s1FL2c8VM1mZXyrimQZye8VPvArotQCdfZkwWjStnwcpVTYXvPTo36ausVHvkm8iwi2Mv.HpQ3deFBcFLDFvCEfZVgsO6Mvt4frrn1gO7BZwHjZ9N.QbyJslG1xorLHBuwZP8QCTWZQGxnAxeadJx3dz1EFMHjKwadjunpn_Vh3yzO9FDSB.fC0R1KVP5HtaC5xm.Q430Pk.96p4OrxpwOXmYy4WH6BsP45ygCX3U13T86ZjCbkZ3Ncoc15wa4HRURz7Jm5r13aLEX5G_2I69iwadLoiW4.06zjt5dhnQaPkEmnTTH6hjyDpbdm.bLvZippY9rTpls3ev5.BQJ4-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AFE1EA9.60102@schaufler-ca.com>
Date: Fri, 13 Nov 2009 19:06:17 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: James Morris <jmorris@namei.org>, Julia Lawall <julia@diku.dk>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>            <4AFCC06B.1030302@schaufler-ca.com> <19857.1258147396@turing-police.cc.vt.edu>
In-Reply-To: <19857.1258147396@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 12 Nov 2009 18:11:55 PST, Casey Schaufler said:
>   
>> James Morris wrote:
>>     
>>> Do you see potential for a buffer overrun in this case?
>>>       
>
>   
>> No, but I hate arguing with people who think that every time
>> they see strcmp that they have found a security flaw.
>>     
>
> How do you feel about people who think every time they see strcmp()
> "Oh crap, something that needs auditing"? ;)
>   

They have my deep sympathy. Which is why I'm advocating leaving
the perfectly functional and correct use of strncmp() as it is.

> The biggest problem with strcmp() is that even if it got audited when that code
> went in, it's prone to unaudited breakage when somebody changes something in
> some other piece of code, quite often in some other .c file in some other
> directory.
>
> Julia, is there a way to use coccinelle to detect unsafe changes like that?  Or
> is expressing those semantics too difficult?
>
>
>   

