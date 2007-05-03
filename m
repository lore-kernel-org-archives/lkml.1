Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXECOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXECOow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXECOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:44:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:16686 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692AbXECOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=U2+zXb2WwkikjYu21zexBhdUahAZvWvvDXHX7Zi3tmh8+zj95xNP4+X1idRnIdNnYAVw3E8wP1JYQQ9E+L7IBnQDtjP5J3a4bK5FwA+N2wj+Ec5KaTgXtTkaEX/R4h1RYHy74ytFnTpTXCoFDOLhmt2sGOIb0iTWnz84No2Dprw=
Message-ID: <4639F554.1040505@gmail.com>
Date: Thu, 03 May 2007 18:44:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<4636E0E2.5020601@simon.arlott.org.uk>	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net> <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
In-Reply-To: <20070503112013.272380@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:

> On the technical layer I noticed that I heard some Pinnacle relais click during testing, but there were some i2c_bus symbols missing during compilation. So I guess those missing symbols are responsible for getting neither picture nor sound.

Can you send your compile warnings ? I couldn't find the same in my
mailbox any report on the same. Maybe my mail filter did something.

> A. If you are really interested I can send you my basic puzzle parts in short, opening a new thread on this issue. Just give me a short response if you are interested.
> 
> B. If you want to continue the cx878 project please drop me a short note where I can download it to test and enlarge it with my own ideas as good as I can.
> 
> Must not be immediately (no sweat please), but I am looking forward to receive a response from you.
> 

What i would like to do is like this: Have the current state frozen as
it is, such that there is a fallback case (The dst is quite fragile and
change at some place would break another. ie, what looks good for one
DST variant is bad for the other). Work on a new tree (CX878) and
migrate stuff to it. Remove the old one, once things are done.

I wouldn't want to mess up the current working situation and hence.

