Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYC2Srs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYC2Srs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYC2Srg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:47:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:43249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbYC2Srg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:47:36 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com>
	<18414.31274.514325.238985@harpo.it.uu.se>
	<jezlshe6u7.fsf@sykes.suse.de>
	<alpine.LNX.1.10.0803291923350.28605@fbirervta.pbzchgretzou.qr>
X-Yow: Is it FUN to be a MIDGET?
Date: Sat, 29 Mar 2008 19:47:34 +0100
In-Reply-To: <alpine.LNX.1.10.0803291923350.28605@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Sat\, 29 Mar 2008 19\:24\:27 +0100 \(CET\)")
Message-ID: <jeprtde5a1.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Saturday 2008-03-29 19:13, Andreas Schwab wrote:
>>> In a language with strict a comma-as-separator rule you can
>>> get this benefit by placing the comma before new items rather
>>> than after existing items:
>>>
>>> enum {	FOO
>>> 	,FIE
>>> 	,FUM
>>> };
>>>
>>> but luckily C doesn't need this perversion.
>>
>> Only since C99 (but GNU C never needed it either).
>
> C had this for much longer than 99. Borland Turbo C from around 1990
> (which you can expect to be C89 if you have luck) also allows , at the end.

C89 definitely does not allow a comma at the end of the enumerator list
(only at the end of the initializer list).  If Borland C allows it in
its strict C89 mode (if it has such a thing) then it is buggy.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
