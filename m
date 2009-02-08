Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZBHJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZBHJNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZBHJMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:12:55 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:18341 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZBHJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aVzMJu98WznrKu4GKfQY5Y7V0BtUKCzljAKhtoOEU/kSYo138c0ddai319tExMwirF
         cfGceg9smCGyYI5/zopXEQ32sGfcNTtoxZPCQc8Bbxbl41sKMdXPf4W8ot3ZruUKDiv9
         JC2lduUlMqFEMRNTLNSAx+3IUvTW8gc6jQiVA=
Date: Sun, 8 Feb 2009 17:12:44 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <gregkh@suse.de>,
       Shane Hathaway <shane@hathawaymix.org>,
       Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090208091244.GB383@hack.private>
References: <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com> <20090119152104.GC6432@c2.user-mode-linux.org> <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com> <49753063.8040007@hathawaymix.org> <alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be> <Pine.LNX.4.64.0902042115530.25136@anakin> <20090204204009.GA10680@suse.de> <Pine.LNX.4.64.0902042150550.25136@anakin> <20090207125956.110591c9@osiris.boeblingen.de.ibm.com> <20090208090642.GA383@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090208090642.GA383@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 05:07:10PM +0800, Américo Wang wrote:
>
>> 	}								\
>>-	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
>>-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
>>+	SYSCALL_ALIAS(sys##name, SyS##name);				\
>>+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
>
>So your final actual name for a syscall 'foo' will be 'sysfoo'
>instead of 'sys_foo', right?
>

Oops, I misread the leading underscore! Sorry.

Looks good then,

Reviewed-by: WANG Cong <wangcong@zeuux.org>


-- 
"Against stupidity, the gods themselves, contend in vain."

