Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZEOVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZEOVuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZEOVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:49:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43967 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbZEOVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=fpGFWZkBzM5RwVR23igLP1CU3DP0vDX4W6VU4jhgQ4GwCM9kOjCYb4NhpKEXEgOxGS
         8ppuguoCoyTLyNw3L+FUeJ8ljVeHIJIj2t2D5M/psVDKrRbBh3iNuVBdZu5ncZZX6mu1
         DF3VdJbWghDoy+NdCgu7lcGrdl0dJi8K3BhjI=
Message-ID: <4A0DE362.4010903@gmail.com>
Date: Fri, 15 May 2009 23:49:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 29/51] mac80211: pid, fix memory corruption
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org> <4A0D0A76.7040806@gmail.com> <20090515144901.GB27812@suse.de>
In-Reply-To: <20090515144901.GB27812@suse.de>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCs chopped.

On 05/15/2009 04:49 PM, Greg KH wrote:
> On Fri, May 15, 2009 at 08:23:50AM +0200, Jiri Slaby wrote:
>> note that you were about to drop this one now because of waiting for a
>> fixup which is not upstream so far. Did anything change?
> 
> Hm, no, I dropped a different patch,
> 	mac80211-minstrel-fix-memory-corruption.patch
> did I drop the wrong one?

The aforementioned fix finally did it in. Please, apply
8e532175277d9a5eae49768ed086555081f741a7
(mac80211: minstrel, fix memory corruption)

6909268dc93ae4b0b8e1ebb4b2fa70b1a47dd347
(mac80211: pid, fix memory corruption)

621ad7c96aa138cfeab53cd4debc5a4e08b2189b
(mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel)

Thanks and sorry for the chaos.
