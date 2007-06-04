Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXFDNcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXFDNcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXFDNcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:32:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:6620 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXFDNci (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:32:38 -0400
Message-ID: <46641472.3080802@de.ibm.com>
Date: Mon, 04 Jun 2007 15:32:34 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070521)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain>	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au>
In-Reply-To: <46612D6F.6000002@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> The question is, why is that not enough (I haven't looked at these
> patches enough to work out if there is anything more they provide).
I think, it just takes trying things out. From reading the code, I 
think this should work well for the filemap_xip code with no struct page.
Also, we need eliminate nopage() to get rid of the struct page. 
Unfortunately I don't find time to try this out for now, and on 390 we 
can live with struct page for the time being. In contrast to the 
embedded platforms, the mem_mep array gets swapped out to disk by our 
hypervisor.

so long,
Carsten
