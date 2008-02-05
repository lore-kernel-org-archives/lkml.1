Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYBEGte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYBEGte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYBEGt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:49:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34757 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbYBEGt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:49:26 -0500
Subject: Re: > best asked at one of the nvidia forums, not on lkml...
From: Zachary Amsden <zach@vmware.com>
To: for.poige+linux@gmail.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <47A805C3.9050303@gmail.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	 <20080202235103.20dd9768.akpm@linux-foundation.org>
	 <47A71040.5000300@gmail.com>
	 <20080204052709.12f4e0d3.akpm@linux-foundation.org>
	 <47A7F4DB.3070406@gmail.com>	<47A80218.3040304@gmail.com>
	 <20080204223430.415161e9@laptopd505.fenrus.org>
	 <47A805C3.9050303@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 22:53:10 -0800
Message-Id: <1202194390.28740.8.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-05 at 13:44 +0700, Igor M Podlesny wrote:
> On 2008-02-05 13:34, Arjan van de Ven wrote:
> [...]
> >> 	1) To have compiled it I had to replace global_flush_tlb()
> >> call with __flush_tlb_all() and still guessing was it(?) a correct
> >> replacment at all :-)
> > 
> > it is not; 
> 
> 	I see, thanks. What would be the correct one? ;-)

global_flush_tlb() would be the correct one.

