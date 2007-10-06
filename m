Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbXJFSvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbXJFSvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760961AbXJFSvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:51:41 -0400
Received: from smtpoutm.mac.com ([17.148.16.68]:59353 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbXJFSvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:51:40 -0400
In-Reply-To: <4706DC09.1060403@zytor.com>
References: <20071005131309.GA445@linux-mips.org> <4706DC09.1060403@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3CD096B0-2235-46AD-B0FC-83ED02778E41@mac.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, bryan.wu@analog.com,
       michael.frysinger@analog.com, robin.getz@analog.com,
       Paul Mackerras <paulus@samba.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Replace __attribute_pure__ with __pure
Date: Sat, 6 Oct 2007 14:49:57 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trimmed the CC list a bit

On Oct 05, 2007, at 20:51:21, H. Peter Anvin wrote:
> Ralf Baechle wrote:
>> To be consistent with the use of attributes in the rest of the  
>> kernel replace all use of __attribute_pure__ with __pure and  
>> delete the definition of __attribute_pure__.
>
> Concern: __attribute_pure__ is very similar to __attribute_const__,  
> which is almost completely, but not totally unlike the keyword  
> "const"...

Yes, there's also the fact that __pure is a reserved GCC keyword.   
Essentially according to GCC docs all of the GCC-specific keywords  
are equivalently defined as "keyword", "__keyword", and  
"__keyword__", with only the latter two defined in strict-ANSI mode.   
The following is valid according to GCC docs:

static int __attribute__((__pure)) my_strlen(const char *str);

With the proposed definition of __pure, that becomes a noticeably  
invalid __attribute__((__attribute__((__pure__))))


Cheers,
Kyle Moffett

