Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYGGPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYGGPoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYGGPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:44:12 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:51258 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYGGPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:44:11 -0400
Message-ID: <487239BE.8070505@de.ibm.com>
Date: Mon, 07 Jul 2008 17:43:58 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Hugh Dickins <hugh@veritas.com>, benh@kernel.crashing.org,
       Zan Lynx <zlynx@acm.org>, Ryan Hope <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <486E4FD8.4010102@acm.org> <Pine.LNX.4.64.0807042112130.16912@blonde.site> <200807071806.11630.nickpiggin@yahoo.com.au>
In-Reply-To: <200807071806.11630.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> I think we need a similar fix for s390 too. If so, then it really should
> get into 2.6.26, but this late in the release, I hope an s390 maintainer
> might be able to test and verify the fix?
I've done my best to combine mprotect, mmap and munmap a MAP_PRIVATE 
mapping on a xip file system. The system runs stable with and without 
this patch. Could someone please enlighten me on how to reproduce the 
problem so that I can verify the fix?
