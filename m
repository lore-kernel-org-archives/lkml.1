Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXKTGqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXKTGqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXKTGqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:46:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbXKTGqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:46:06 -0500
Message-ID: <4742825F.9000109@zytor.com>
Date: Mon, 19 Nov 2007 22:44:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
References: <MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> 
> Any UUID generator that can produce duplicate UUIDs with probability
> significantly less than purely random UUIDs is so badly broken that it
> should not ever be used. Anyone who finds such a UUID generator should
> immediately either fix it or throw it on the junk heap. Anyone who knowingly
> uses such a UUID generator should be publically shamed.
> 
> Rather than (or at the very least, in addition to) adding a new UUID
> generator, let's fix the one(s) we have.
> 

I presume you mean "significantly higher."

Realistically speaking, a random UUID is probably the best you're going 
to ever get.  I highly suspect that any time- and MAC-address-based 
solution is going to suffer from mis-set clocks and misprogrammed MAC 
addresses more often than you will have collisions in a 122-bit random 
number.

	-hpa
