Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbXHUSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbXHUSoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbXHUSo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:44:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393AbXHUSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:44:26 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Software based ECC ?
To: Folkert van Heusden <folkert@vanheusden.com>, Valdis.Kletnieks@vt.edu,
       roland <devzero@web.de>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 21 Aug 2007 20:44:01 +0200
References: <8QK3R-kc-9@gated-at.bofh.it> <8QSuw-4J2-9@gated-at.bofh.it> <8RoXy-3NJ-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1INYht-0000Xw-Ay@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19PA7WmRTDCs3JW2++YGIGogQN4tkOX3JWfdPC
 T9tA7RrZo4U5zpLeMW36Lzrz8vh4Nh+YP38/TuGAmsaPNi/a1Y
 jFiG00FIybqlAkmQR7BzQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden <folkert@vanheusden.com> wrote:

>> > http://pdos.csail.mit.edu/papers/softecc:ddopson-meng
softecc_ddopson-meng.pdf
>> > "SoftECC : A System for Software Memory Integrity Checking"
>> 
>> Personally, I'd recommend just shelling out the bucks for hardware ECC if
>> the reliability matters.
> 
> a question and an idea: Q: is ecc guaranteed to detect all bitflips?

It's guaranteed not to.

Having n extra bits, you can detect n-bit-flips and correct n/2-bit-flips
(provided you use an optimal code).

These extra bits can flip, too, so if you have m >= 1 data bits and any
finite number n of extra bits, it's possible to have an undetectable
n+1-bit-flip.
-- 
If you can't remember, then the claymore IS pointed at you. 

Friﬂ, Spammer: W@2fzbe.7eggert.dyndns.org k@-.7eggert.dyndns.org
 Rtc@Ytzq.7eggert.dyndns.org 9qKSiPo@ZesTis.7eggert.dyndns.org
