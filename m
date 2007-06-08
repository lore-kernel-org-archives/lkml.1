Return-Path: <linux-kernel-owner+w=401wt.eu-S968697AbXFHIGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968697AbXFHIGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938800AbXFHHjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:39:15 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:15338 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938799AbXFHHjN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:39:13 -0400
Message-ID: <4669079B.3030408@de.ibm.com>
Date: Fri, 08 Jun 2007 09:39:07 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com> <20070607193707.GA17144@infradead.org> <20070607194054.GC17144@infradead.org>
In-Reply-To: <20070607194054.GC17144@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> And for thus just wanting to take a quick glance, this is the
> diff vs an out of tree cramfs where uncompress.c and cramfs_fs_sb.h
> are merged into inode.c:
Mkay, I am convinced. Either cramfs should be based on a block device 
that does have direct_access() for xip, or the code needs to be 
forked. Looks like a sane approach to me.

so long,
Carsten
