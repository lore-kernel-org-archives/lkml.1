Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZFAEqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZFAEqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFAEqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:46:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51211
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbZFAEqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:46:23 -0400
Date: Sun, 31 May 2009 21:46:23 -0700 (PDT)
Message-Id: <20090531.214623.76344831.davem@davemloft.net>
To: riel@redhat.com
Cc: research@subreption.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
       alan@lxorguk.ukuu.org.uk, linux-crypto@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
 key/iv handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A22967C.3080304@redhat.com>
References: <20090531025720.GC9033@oblivion.subreption.com>
	<20090530.230213.73434433.davem@davemloft.net>
	<4A22967C.3080304@redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>
Date: Sun, 31 May 2009 10:38:52 -0400

> David Miller wrote:
>> From: "Larry H." <research@subreption.com>
>> Date: Sat, 30 May 2009 19:57:20 -0700
>> 
>>> [PATCH] Use kzfree in crypto API context initialization and key/iv
>>> handling
>> Thanks for not CC:ing the crypto list, and also not CC:'ing the
>> crypto maintainer.
>> Your submissions leave a lot to be desired, on every level.
> 
> That's a pretty roundabout way of saying "I have no
> technical objections" :)

One of those "levels" was technical.

I don't even want to think about what this does to IPSEC rule creation
rates, that that matters heavily for cell phone networks where
hundreds of thousands of nodes come in and out of the server and each
such entry requires creating 4 IPSEC rules.
