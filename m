Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYGVOxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYGVOxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYGVOwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:52:55 -0400
Received: from gw.goop.org ([64.81.55.164]:57478 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYGVOwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:52:55 -0400
Message-ID: <4885F43B.7060307@goop.org>
Date: Tue, 22 Jul 2008 07:52:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
References: <200807221431.58991.rusty@rustcorp.com.au>	<488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>	<4885774E.3000909@goop.org> <873am2kr4n.fsf@saeurebad.de>
In-Reply-To: <873am2kr4n.fsf@saeurebad.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> PTE_PFN_MASK is not symmetric to PAGE_MASK.

No, it isn't.  Is there anything about the name that suggests that it 
should be?  PTE_PFN_MASK is for operating on pteval_t-typed values 
extracted from ptes; PAGE_MASK is for operating on addresses.

>   How about PTE_PROT_MASK?
>   

That's the opposite sense; the next patch defines it as PTE_FLAGS_MASK.

    J
