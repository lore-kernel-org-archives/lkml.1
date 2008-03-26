Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbYCZR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbYCZR6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYCZR6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:58:05 -0400
Received: from usea-naimss3.unisys.com ([192.61.61.105]:4651 "EHLO
	usea-naimss3.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYCZR6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:58:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] CPUs on memoryless nodes not being reassigned
Date: Wed, 26 Mar 2008 12:57:58 -0500
Message-ID: <7ECBFE60CB7F02478CDDDE40C985813A08911BC9@USEA-EXCH4.na.uis.unisys.com>
In-Reply-To: <20080326131021.GA16852@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] CPUs on memoryless nodes not being reassigned
Thread-Index: AciPQ1JpQkN6BXd2ST+AAeEPlF4zEAAJ2oyw
References: <1206535469.7468.9.camel@localhost.localdomain> <20080326131021.GA16852@elte.hu>
From: "Yeisley, Dan P." <dan.yeisley@unisys.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>, <ak@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
X-OriginalArrivalTime: 26 Mar 2008 17:57:58.0904 (UTC) FILETIME=[ED350780:01C88F6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Wednesday, March 26, 2008 9:10
> To: Yeisley, Dan P.
> Cc: linux-kernel@vger.kernel.org; ak@suse.de; Yinghai Lu
> Subject: Re: [PATCH] CPUs on memoryless nodes not being reassigned
> 
> 
> * Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> 
> > When I boot with memoryless nodes on the latest 2.6.25-rc kernels,
the
> > CPUs aren't being reassigned to nodes with memory.
> 
> >  	node = apicid_to_node[apicid];
> > -	if (node == NUMA_NO_NODE)
> > +	if (node == NUMA_NO_NODE || !node_online(node))
> >  		node = first_node(node_online_map);
> 
> that's already fixed in x86.git/latest, by Yinghai Lu, could you try
it:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> (let me know if there's any other problem with your hardware on
> x86.git/latest.)
> 
> 	Ingo

I tried the x86.git/latest and it worked.

Dan
