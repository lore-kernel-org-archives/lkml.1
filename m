Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0ARQWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0ARQWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547Ab0ARQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:22:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:13339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0ARQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sk6JQDPLFu4b5y81wkQvrfcarIWZP1PJDPveb/z2YKCU0CGyMUuWZ2VGZrxZY1DNXL
         q326mlof/qbOUMRY8oYeEkdZHvMb3H/QWPHfzi1agTztokjwAL+a8gehpiVnV+HVTbt4
         Wgm1FvUfXSsRtV4wI2hPJyRbrxc1y7tniIMS4=
Date: Mon, 18 Jan 2010 17:22:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118162209.GH10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825421.4283.597.camel@laptop> <20100118145346.GF10364@nowhere> <1263826798.4283.606.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263826798.4283.606.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:59:58PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 15:53 +0100, Frederic Weisbecker wrote:
> 
> > Not sure what you both mean by this core VS uncore thing :)
> > Is it about hardware counters that apply to single hardware threads
> > or shared among them inside a same core?
> 
> Yeah intel has two PMUs, one per logical cpu and one per socket/node. We
> currently don't support the node one yet.
> 
> So the thing with these socket wide things is is that they are not able
> to tell where the event originated, so relating that back to a task is
> only possible when there's only one task running.
> 


Ah ok.

