Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYGIJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYGIJWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYGIJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 05:22:11 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22297 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYGIJWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 05:22:10 -0400
Message-ID: <48748340.1060603@msgid.tls.msk.ru>
Date: Wed, 09 Jul 2008 13:22:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
References: <4873E27C.6050504@msgid.tls.msk.ru> <200807091032.14786.oliver@neukum.org>
In-Reply-To: <200807091032.14786.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Dienstag 08 Juli 2008 23:56:12 schrieb Michael Tokarev:
> 
>> Any idea how to start welcome.  Meanwhile I'll try current 2.6.26pre,
>> in a hope it will not destroy all our data.. ;)
> 
> Can you test whether select() triggers the lockup?

Hmm.  Sure I can, and it definitely uses select() here and there -
samba & Oracle8 & cronyd & vtund & syslogd - that's services
running on it all using select(2).  Can you elaborate a bit
more on this please?  I mean, should it lock up on first select()
(so that it's not what I see here) or on some random one (still
may be the situation I see), or not so-random which is more-or-less
possible to trigger?

Thank you for the reply!

/mjt
