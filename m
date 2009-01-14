Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbZANLlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbZANLlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbZANLlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:41:23 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1803 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221AbZANLlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:41:21 -0500
Date: Wed, 14 Jan 2009 12:41:07 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Message-ID: <20090114114059.GA23674@vanheusden.com>
References: <1231774622.4371.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231774622.4371.96.camel@laptop>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 15 09:10:29 CET 2009
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The key criteria for the busy wait is that the lock owner has to be running on
> a (different) cpu. The idea is that as long as the owner is running, there is a
> fair chance it'll release the lock soon, and thus we'll be better off spinning
> instead of blocking/scheduling.

Won't this make Linux less "green"? (-> use more power since busy loops
use more power than idle loops) If so, maybe it should be make
configurable somewhere?


Folkert van Heusden

-- 
MultiTail is een flexibele tool voor het volgen van logfiles en
uitvoer van commando's. Filteren, van kleur voorzien, mergen,
'diff-view', etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
