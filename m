Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbXIXMjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbXIXMjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXIXMji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:39:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:45757 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXIXMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=S1DzfMgmW9Qr1xfBk81SAmRsl362RCd0Y/cphMPhGKUSxH75Xs7IWKbWkFS8RwYPAPOjrgMfVFFgfKxZdm/74UWUXBdR5ftSwGLFoqV1OJe+3CEepwyCLJOf6jOVFJyiKxOWCrA5oQz81FiDUJh9JbhvXaE+3y5V6Q1ppxQcuzs=
Message-ID: <46F7B006.40309@gmail.com>
Date: Mon, 24 Sep 2007 14:39:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Antoine Zen-Ruffinen <antoine.zen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Compilation problem with kernel 2.6.9
References: <2cbbd8de0709240252x34d4d66ci6bd2e20e397a7cc1@mail.gmail.com>
In-Reply-To: <2cbbd8de0709240252x34d4d66ci6bd2e20e397a7cc1@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 11:52 AM, Antoine Zen-Ruffinen wrote:
> Hello,
> 
> I tried to compile the kernel 2.6.9 because I want to use it with
> RTLinux and that the only 2.6.x kernel supported. I used gcc 2.95.3 as
> recommended.
> But I have an error by compilation of process.c :
> 
>   CC      arch/i386/kernel/process.o
> {standard input}: Assembler messages:
> {standard input}:777: Error: suffix or operands invalid for `mov'
> {standard input}:778: Error: suffix or operands invalid for `mov'
> {standard input}:978: Error: suffix or operands invalid for `mov'
> {standard input}:979: Error: suffix or operands invalid for `mov'
> {standard input}:1051: Error: suffix or operands invalid for `mov'
> {standard input}:1052: Error: suffix or operands invalid for `mov'
> {standard input}:1161: Error: suffix or operands invalid for `mov'
> {standard input}:1162: Error: suffix or operands invalid for `mov'
> {standard input}:1172: Error: suffix or operands invalid for `mov'
> {standard input}:1184: Error: suffix or operands invalid for `mov'
> make[1]: *** [arch/i386/kernel/process.o] Error 1
> make: *** [arch/i386/kernel] Error 2
> 
> Can someone help me ?

Probably use older binutils, your gas is too new and doesn't like the input.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
