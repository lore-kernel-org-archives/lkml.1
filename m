Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYDRISo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYDRISo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYDRISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:18:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:42123 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYDRISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:18:31 -0400
Subject: Re: [PATCH 2/3] [POWERPC] Fix kernel stack allocation alignment
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <20080418000618.0c46c78f.akpm@linux-foundation.org>
References: <20080418065727.5FE1CDE247@ozlabs.org>
	 <20080418000618.0c46c78f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 18:18:18 +1000
Message-Id: <1208506698.6958.400.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> so...  the "0" defeats all of SLAB_DEBUG_FREE, SLAB_RED_ZONE, SLAB_POISON
> and SLAB_STORE_USER, if the comment in slab.h is to be believed.
> 
> Was that overkill?

Well, I copied over from something else, looks like there's a -lot- of 0
users here... 

Shouldn't there be some kind of SLAB_DEFAULT that contain those things ?

Ben.


