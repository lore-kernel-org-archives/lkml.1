Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbYASGU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbYASGU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYASGUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:20:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:11662 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYASGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qx/g5mwMF45S9eaY16xj/8B8DrMNnhPY1zeDAVmHtBjj2DL8wNKoCwSCumtqnrJd8eoYL2tA8kLCQqFmeGnYKY1DK9VPUQuoXpL8CYUDQiY4+9KArEfF1oJjT9iTuobiJ0Hz5Da4zc+8uHmWS6btfRDLjb13pm3e4fqemNI/kFc=
Message-ID: <86802c440801182220h640dc0csabd92e715d4e79d0@mail.gmail.com>
Date: Fri, 18 Jan 2008 22:20:11 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
Cc: travis@sgi.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@suse.de>, mingo@elte.hu,
       "Christoph Lameter" <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <alpine.DEB.0.9999.0801182116380.10040@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118183011.354965000@sgi.com>
	 <20080118183011.527888000@sgi.com>
	 <86802c440801182003vd94044ex7fb13e61e5f79c81@mail.gmail.com>
	 <alpine.DEB.0.9999.0801182026130.32726@chino.kir.corp.google.com>
	 <86802c440801182043l1f36086bq51d1fa0528e6bd74@mail.gmail.com>
	 <alpine.DEB.0.9999.0801182116380.10040@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 9:17 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 18 Jan 2008, Yinghai Lu wrote:
>
> > > > I got
> > > > SART: PXM 0 -> APIC 0 -> Node 255
> > > > SART: PXM 0 -> APIC 1 -> Node 255
> > > > SART: PXM 1 -> APIC 2 -> Node 255
> > > > SART: PXM 1 -> APIC 3 -> Node 255
> > > >
> > >
> > > I assume this is a typo and those proximity mappings are actually from the
> > > SRAT.
> >
> > SRAT for processor only have
> > PXM and APIC id. setup_node(pxm) will get node id for pxm, start from 0...
> >
>
> I was referring to "SART" in your log.

i should copy it instead of type it...

YH
