Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXELHeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXELHeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbXELHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:34:09 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:56131 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbXELHeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=N9OvliACLFjy0IWdWPhBHRm3PiXY/tYRf98xO+WkPEh1ixzm0c6AUnBySyu44ieqb4im0FKLjiuZqR8GU1E2vTbUZsW18lgg9MxchXSzsystIIBW5xD8l5Idt9WtjqnYK1XXpC72GSj2srBvgT5E1ciZ5Qp2jL9u7LB88GRPUnA=
Message-ID: <46456DDE.5070006@gmail.com>
Date: Sat, 12 May 2007 13:03:50 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Satyam Sharma <satyam.sharma@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com> <46456B18.9060605@s5r6.in-berlin.de>
In-Reply-To: <46456B18.9060605@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Satyam Sharma wrote:
>> Coming back to the document, we do need to document / find
>> consensus on the "preferred" way to do similar business in the
>> kernel, and my opinion as far as that is concerned is to shun
>> volatile wherever possible (which includes the case originally
>> discussed above).
> 
> I too recommend that volatile-considered-harmful.txt is not watered down
> by an ever growing "but if" list.  If anybody knows what he does, he
> still can program in a deviating way --- provided that he leaves a brief
> comment in the code, telling why it is possible and beneficial to use
> the volatile qualifier in this special case.

yes, this seems the better option. generally, the more complex rules you
have, the more people tend to break it (either through not being able t
comprehend it or cos it's too difficult to follow).

i believe, the doc here is pretty unambiguous regarding the fact that
volatile should be avoided. And as Stefan pointed out, anyone who feels
the need to use, must surely _know_ what he is doing & hence is in a
position t make that decision (followed ofcourse with a doc of why it
was done).

it would be better we didn't grow the list of exceptions - IMHO.

-jb
-- 
Tact is the art of making a point without making an enemy.
