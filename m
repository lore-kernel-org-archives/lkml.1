Return-Path: <linux-kernel-owner+w=401wt.eu-S1032371AbXFHXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032371AbXFHXCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 19:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXFHXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 19:02:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38593 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXFHXCm (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 19:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XrTOMCpB6fY6M13Uf2QrfRI54BSz5LAqq02rtADGijtPujVY0q8izJ8NqZ/LhG/SpVz/d9sFmh6IcjVZBlhqJHX7F6MLjzP41Uvp8F/2kgc1Hvfzwq4AXR839N9TaWZE9/Xf7a8Xyc1+IOqdPcQ39RQtILp7xV0yPJDOvzeONWA=
Message-ID: <6934efce0706081602x40985824g247a6f244b038dd3@mail.gmail.com>
Date: Fri, 8 Jun 2007 16:02:41 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <4669A831.3040105@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4669027E.3070406@de.ibm.com>
	 <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com>
	 <20070608080401.GA17684@infradead.org>
	 <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com>
	 <20070608160929.GA3366@infradead.org>
	 <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com>
	 <20070608161526.GA3729@infradead.org>
	 <20070608175152.GG20718@lazybastard.org> <4669A831.3040105@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The downside: We need mem_map[] struct page entries behind all memory
> segments. Nowerdays we can easily create those via vmem_map/sparsemem.
>
> Opinions?

Frankly this is going to be mostly relevant on ARM architectures at
least at first.  Maybe I'm missing something but I don't see that
sparemem is supported on ARM...
