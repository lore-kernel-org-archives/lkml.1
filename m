Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZDJQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZDJQTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbZDJQT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:19:27 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19422 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZDJQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:19:26 -0400
Message-ID: <49DF718B.9050809@hp.com>
Date: Fri, 10 Apr 2009 12:19:23 -0400
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 10/30] cr: core stuff
References: <20090410023539.GK27788@x200.localdomain>	<20090410093520.GH17962@elte.hu> <20090410114326.GC3311@x200.localdomain>
In-Reply-To: <20090410114326.GC3311@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> And of course, I don't want to see multiline
> 
> 	vmflags &= ~(VM_READ|VM_WRITE|
> 			[5 lines skipped]

Then why don't you:

#define VM_CR_FOO (VM_READ|VM_WRITE|...)

	vmflags &= ~VM_CR_FOO;

-Brian

