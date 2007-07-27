Return-Path: <linux-kernel-owner+w=401wt.eu-S935936AbXG0KWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935936AbXG0KWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762181AbXG0KWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:22:40 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:44387 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760084AbXG0KWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:22:39 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
References: <200707270944.LAA17167@ifs.emn.fr>
	<20070727100004.GV27237@ftp.linux.org.uk>
Date: Fri, 27 Jul 2007 12:21:53 +0200
In-Reply-To: <20070727100004.GV27237@ftp.linux.org.uk> (Al Viro's message of
	"Fri, 27 Jul 2007 11:00:04 +0100")
Message-ID: <87hcnq9mf2.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> writes:

> On Fri, Jul 27, 2007 at 11:44:35AM +0200, Yoann Padioleau wrote:
>>  	pte = pte_alloc_kernel(pme, va);
>> -	if (pte != 0) {
>> +	if (pte != NULL) {
>>  		err = 0;
>>  		set_pte(pte, mk_pte_phys(pa & PAGE_MASK, prot));
>>  	}
>> @@ -99,7 +99,7 @@ void *consistent_alloc(gfp_t gfp, size_t
>>  
>>  	/* allocate some common virtual space to map the new pages */
>>  	area = get_vm_area(size, VM_ALLOC);
>> -	if (area == 0) {
>> +	if (area == NULL) {
>>  		free_pages(page, order);
>>  		return NULL;
>
> Same comment about comparisons with NULL after allocation...

I don't understand. pte is a pointer right ? So why should we
keep the == 0 ? 

