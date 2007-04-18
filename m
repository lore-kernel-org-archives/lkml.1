Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXDRWz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXDRWz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXDRWz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:55:26 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:33087 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbXDRWzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:55:25 -0400
Message-ID: <4626A1D9.3030104@gmail.com>
Date: Thu, 19 Apr 2007 00:55:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] Char: tty, add io tty_insert_flip_string variants
References: <21144242611885323036@karneval.cz> <20070418234144.3b183123@the-village.bc.nu>
In-Reply-To: <20070418234144.3b183123@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 19 Apr 2007 00:55:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
> On Thu, 19 Apr 2007 00:35:20 +0200 (CEST)
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hi,
>>
>> don't you consider this useful for some drivers. There are many cases, when
>> tty_insert_flip_stringio might be used.
> 
> I couldn't see anyone who really benefitted when I first looked at this
> but if you've got a case you want to use them then I've certainly got no
> problem with it.

Ah, I'm an idiot -- I should go through the code more carefully,
tty_prepare_flip_string + memcpy_fromio can do the job.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
