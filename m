Return-Path: <linux-kernel-owner+w=401wt.eu-S1763018AbXHALoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763018AbXHALoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXHALoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:44:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495AbXHALoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:44:14 -0400
Date: Wed, 1 Aug 2007 13:44:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
In-Reply-To: <E1IGBiG-0006fv-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0708011341160.26668@fbirervta.pbzchgretzou.qr>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <p73myxbpm8r.fsf@bingen.suse.de>
 <E1IGAx0-0006TK-00@dorka.pomaz.szeredi.hu> <p73643zpjy8.fsf@bingen.suse.de>
 <E1IGBiG-0006fv-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1 2007 12:45, Miklos Szeredi wrote:
>> > 
>> > #define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))
>> 
>> The cast doesn't make it more safe in any way
>
>I does, since a warning will be issued, if the type of the assigned
>pointer doesn't match the requested allocation.
>
>And yes, warnings are _very_ useful in C for enforcing type safety.

	void *p;
	p = (struct foo *)kmalloc(sizeof(struct foo), GFP_KERNEL);



	Jan
-- 
