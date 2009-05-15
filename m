Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZEOPKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZEOPKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZEOPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:09:52 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49084 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZEOPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vcs0WDhvV/dUzs8lbWWnVY2eHpdCE+DKlD8AEw547nHX6XMWUoGwWiGuba8+wB2aFQ
         lG/0QcsYCm0fFh8Nb97KSNZj3a0ucHxL4P9qyarJMN+CRV2o+Dw5up2Yg9efaMp0U9ON
         Rrz3b7zZETIFV7lAJk+XHQU/qlz8KF89bLnVc=
Message-ID: <4A0D85A3.1030806@gmail.com>
Date: Fri, 15 May 2009 17:09:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 29/51] mac80211: pid, fix memory corruption
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org> <4A0D0A76.7040806@gmail.com> <20090515144901.GB27812@suse.de>
In-Reply-To: <20090515144901.GB27812@suse.de>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2009 04:49 PM, Greg KH wrote:
> On Fri, May 15, 2009 at 08:23:50AM +0200, Jiri Slaby wrote:
>> Hi,
>>
>> note that you were about to drop this one now because of waiting for a
>> fixup which is not upstream so far. Did anything change?
> 
> Hm, no, I dropped a different patch,
> 	mac80211-minstrel-fix-memory-corruption.patch
> did I drop the wrong one?
> 
> 
> Should I bring that one back and drop the one below?
> 
> confused,

Ah, sorry for the confusion, I didn't realize there are 2 of them. Both
suffer from the same, because it's a cut&paste code.

Please drop this one too.

Thanks.
