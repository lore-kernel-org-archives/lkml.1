Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbXFMALa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbXFMALa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXFMALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:11:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:37683 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXFMALV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DJWINpYVIoNbM9KmzFTSATq/h9j1ouj4itWRx+whYVsTZgce4MTypCikX8Zk1j7v6j5u5uzBCBN+iwoAarvZ+T45H4dMgPNCDkCmyJBxvEPx1trcCi+KjegGUGi/eMZtACxbpaehzDyUMZZyI9v0s/JH55jWW2aIZaFtr7F9yJY=
Message-ID: <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com>
Date: Tue, 12 Jun 2007 17:11:20 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <46641472.3080802@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Nick Piggin wrote:
> > The question is, why is that not enough (I haven't looked at these
> > patches enough to work out if there is anything more they provide).
> I think, it just takes trying things out. From reading the code, I
> think this should work well for the filemap_xip code with no struct page.
> Also, we need eliminate nopage() to get rid of the struct page.
> Unfortunately I don't find time to try this out for now, and on 390 we
> can live with struct page for the time being. In contrast to the
> embedded platforms, the mem_mep array gets swapped out to disk by our
> hypervisor.

Can you help me understand the comment about nopage()?  Do you mean
set xip_file_vm_ops.nopage to NULL?
