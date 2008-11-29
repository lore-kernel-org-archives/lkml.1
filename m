Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYK2PCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYK2PCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 10:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYK2PB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 10:01:56 -0500
Received: from mail.suse.de ([195.135.220.2]:47456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYK2PBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 10:01:55 -0500
From: Andreas Schwab <schwab@suse.de>
To: roel kluin <roel.kluin@gmail.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs,si}_close() both unsigned hp->count and hvcsd->open_count cannot be negative
References: <4931201D.7060701@gmail.com> <jey6z24rqw.fsf@sykes.suse.de>
	<49314334.6060609@gmail.com>
X-Yow: I'm an East Side TYPE..
Date: Sat, 29 Nov 2008 16:01:47 +0100
In-Reply-To: <49314334.6060609@gmail.com> (roel kluin's message of "Sat, 29
	Nov 2008 08:27:16 -0500")
Message-ID: <jetz9q4lus.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin <roel.kluin@gmail.com> writes:

> Andreas Schwab wrote:
>> roel kluin <roel.kluin@gmail.com> writes:
>> 
>>> -	if (--hvcsd->open_count == 0) {
>>> +	if (hvcsd->open_count == 1) {
>>> +		hvcsd->open_count--;
>> 
>> This is not the same.
>
> I think you're missing that I also decrement if (hvcsd->open_count > 1)

Yes, sorry, I missed that.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
