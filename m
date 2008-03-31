Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYCaDhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYCaDhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 23:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYCaDho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 23:37:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:52802 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYCaDhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 23:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XL6ckKA1uSV43ZQO48/qiJiZ9e1NLIOv1Sovpyap2aBUKDHggR8eYXv4lJnDMGxJIjlmfnELfypu8A0SnadeuJ4QnBQbSfXLfXK+K0bHV1yFveu4dNM988BigbCSqF29gFIHMuu9NNDrrxy2RGbn5Kh98iHhR6gNkWKsTUV1u3U=
Message-ID: <8499950a0803302037w745c4155r2e820b2a44c28047@mail.gmail.com>
Date: Mon, 31 Mar 2008 04:37:41 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: style of function definitions (Re: [patch] bkl2mtd: cleanup)
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Ingo Molnar" <mingo@elte.hu>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Joern Engel" <joern@logfs.org>,
       "David Miller" <davem@davemloft.net>, jirislaby@gmail.com,
       joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <alpine.LNX.1.10.0803300727120.28605@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080323.051929.267232495.davem@davemloft.net>
	 <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu>
	 <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org>
	 <20080326101452.GA17176@elte.hu>
	 <20080326104821.GS10722@ZenIV.linux.org.uk>
	 <20080326111021.GF17176@elte.hu> <E1JfpB2-00036u-2G@flower>
	 <alpine.LNX.1.10.0803300727120.28605@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt @ Sun, Mar 30, 2008 at 6:31 AM:

>  > No matter what coding style is, the winner is "linux-2.6/fs/xfs", and
>  > i doubt anyone can fix that :)
>
>  They at least have an excuse of having a historical unix background :)

i.e. zoo of proprietary versions, expensive, without reliable implementation
of basic tools and compilers, etc.

Historical UNIX(R) isn't that good at all. Now it's POSIX(R) forcing all
new development back.

http://kernelnewbies.org/olecom#trailing_comments_crap
http://kernelnewbies.org/olecom#trailing_multiline_comments_crap

Q: why every parameter is on new line?
A: thus we have more actual code line count

Q: why trailing comments on every parameter?
A: our C compiler have (had) 8 characters limit for variable names

Q: don't you think streaming editor can handle that?
A: our tools have not such thing

Q: you have multi-line trailing comments there, don't you know
   it complicates line-oriented grep-like text processing?
   why don't you write freely in comment block before function definition?
A: why do you care?

-- 
-o--=O`C
 #oo'L O
<___=E M
