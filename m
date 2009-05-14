Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbZENN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbZENN5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZENN5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:57:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbZENN5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:57:19 -0400
Date: Thu, 14 May 2009 16:02:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-x86_64@vger.kernel.org, mingo@elte.hu, zwane@arm.linux.org.uk
Subject: Re: [PATCH 0/4] x86-64: fix vclock_gettime()
Message-ID: <20090514140247.GC10933@one.firstfloor.org>
References: <cover.1242299014.git.ptesarik@suse.cz> <20090514125825.GA10933@one.firstfloor.org> <1242306085.19219.2.camel@nathan.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242306085.19219.2.camel@nathan.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, this doesn't work, because the function is inlined. And even if
> it wasn't, the vDSO must be self-contained by definition. User-space
> cannot simply call into kernel-space.

Wrong, it can call into vsyscall space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
