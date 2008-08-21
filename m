Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYHUKVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYHUKVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYHUKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:21:32 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46704 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYHUKVb (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:21:31 -0400
Message-ID: <48AD4160.7000408@de.ibm.com>
Date: Thu, 21 Aug 2008 12:20:16 +0200
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
To: David Woodhouse <dwmw2@infradead.org>
CC: carsteno@de.ibm.com, jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
References: <48AD00F8.1030004@gmail.com>  <48AD2AFF.5060609@de.ibm.com> <1219308560.2988.247.camel@pmac.infradead.org>
In-Reply-To: <1219308560.2988.247.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-08-21 at 10:44 +0200, Carsten Otte wrote:
>> Jared Hulbert wrote:
>>> Profiling is a fault instrumentation and /proc formating system.
>>> This is used to get an accurate picture of what the pages are actually used.
>>> Using this info the image can be optimized for XIP
> 
>> Exporting profiling data for a file system in another file system 
>> (/proc) seems not very straigtforward to me. I think it is worth 
>> considering to export this information via the same mount point.
> 
> I would have said sysfs, rather than 'the same mount point'.
Well, filesystems are usually not represented in the device model. 
It'd be possible to add a system device for it, but that does'nt feel 
like the right solution to me.
