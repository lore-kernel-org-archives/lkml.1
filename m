Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYHKWuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYHKWuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYHKWuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:50:46 -0400
Received: from gw.goop.org ([64.81.55.164]:40235 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYHKWuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:50:46 -0400
Message-ID: <48A0C22D.2050400@goop.org>
Date: Mon, 11 Aug 2008 15:50:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Andrew Morton <akpm@linux-foundation.org>, ehabkost@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] add phys_addr_t for holding physical addresses
References: <489B6B40.5050705@goop.org>	 <20080807145648.ab3dfa90.akpm@linux-foundation.org>	 <489B72C3.30603@goop.org>	 <20080807162741.8dfcd336.akpm@linux-foundation.org>	 <489B8908.2010007@goop.org>	 <20080807170617.79ca3ce7.akpm@linux-foundation.org>	 <48A0954E.20400@goop.org> <1218491896.8041.9.camel@pasglop>	 <48A0B9EB.9020709@goop.org> <1218493925.8041.21.camel@pasglop>
In-Reply-To: <1218493925.8041.21.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Are we sure resource_size_t is -never- used to represent memory ? I
> though it was on some platforms....

On x86 it's optionally used to put memory in the resource tree, but if 
the memory is larger than can be held in resource_size_t it simply skips 
it.  Don't know about elsewhere.

    J

