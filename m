Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbXFFMF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbXFFMF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762366AbXFFMFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:05:50 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47003 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbXFFMFt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:05:49 -0400
Message-ID: <4666A319.1010901@de.ibm.com>
Date: Wed, 06 Jun 2007 14:05:45 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
In-Reply-To: <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> (2) failed with the following messages.  (This wasn't really busybox.
> It was xxd, not statically link, hence the issue with ld.so)
Could you try to figure what happend to subject page before? Was it 
subject to copy on write? With what flags has this vma been mmaped?

thanks,
Carsten
