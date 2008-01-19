Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYASFSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYASFSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYASFSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:18:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYASFSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:18:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=L+UmnWE+lzoZissqruVCwO2SC2PQqJVMBFQT5TzDmlje3KimoDXxM70nm3Kd+xzlF
	RThQl5PGS90xVhA1fxceg==
Date: Fri, 18 Jan 2008 21:17:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, mingo@elte.hu,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
In-Reply-To: <86802c440801182043l1f36086bq51d1fa0528e6bd74@mail.gmail.com>
Message-ID: <alpine.DEB.0.9999.0801182116380.10040@chino.kir.corp.google.com>
References: <20080118183011.354965000@sgi.com>  <20080118183011.527888000@sgi.com>  <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>  <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
 <86802c440801182043l1f36086bq51d1fa0528e6bd74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Yinghai Lu wrote:

> > > I got
> > > SART: PXM 0 -> APIC 0 -> Node 255
> > > SART: PXM 0 -> APIC 1 -> Node 255
> > > SART: PXM 1 -> APIC 2 -> Node 255
> > > SART: PXM 1 -> APIC 3 -> Node 255
> > >
> >
> > I assume this is a typo and those proximity mappings are actually from the
> > SRAT.
> 
> SRAT for processor only have
> PXM and APIC id. setup_node(pxm) will get node id for pxm, start from 0...
> 

I was referring to "SART" in your log.
