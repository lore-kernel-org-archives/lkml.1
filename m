Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYHUK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYHUK1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbYHUK0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:26:46 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:40415 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbYHUK0o (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:26:44 -0400
Message-ID: <48AD42AE.4030107@de.ibm.com>
Date: Thu, 21 Aug 2008 12:25:50 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
References: <48AD00C4.6060302@gmail.com>
In-Reply-To: <48AD00C4.6060302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> I'd like to get a first round of review on my AXFS filesystem.
I like the general approach of it. It's much more flexible than the 
ext2 extension I've done, and the possibility to select XIP vs. 
compression per page is really really neat. I can imagine that people 
will prefer this over the ext2 implementation on s390. It is unclear 
to me how the "secondary block device" thing is supposed to work. 
Could you elaborate a bit on that?

