Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbZENMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbZENMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbZENMxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:53:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57966 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbZENMxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:53:03 -0400
Date: Thu, 14 May 2009 14:58:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org, zwane@arm.linux.org.uk
Subject: Re: [PATCH 0/4] x86-64: fix vclock_gettime()
Message-ID: <20090514125825.GA10933@one.firstfloor.org>
References: <cover.1242299014.git.ptesarik@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To rectify the situation, I saw the following options:
> 
>  1. Adjust pointers in the vDSO .altinstruction section during
>     vDSO setup, and then pass it to apply_alternatives()
>  2. List the relocations with objdump and add them again to vdso.S
>     using the .reloc GAS directive
>  3. Link the vDSO into the kernel with relocations, i.e. not just
>     as a blob

4. Just move the barriers back back into the main kernel.

-Andi
