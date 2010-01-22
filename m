Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0AVQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0AVQWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414Ab0AVQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:22:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:36071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0AVQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:22:43 -0500
Subject: Re: [PATCH 08/10] perf_event: Optimize the constraint searching
 bits
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu, davem@davemloft.net,
       robert.richter@amd.com, linux-kernel@vger.kernel.org
In-Reply-To: <bd4cb8901001220808n6f731d79m7195eea8e16f57d4@mail.gmail.com>
References: <20100122155044.391857484@chello.nl>
	 <20100122155535.887853503@chello.nl>
	 <bd4cb8901001220808n6f731d79m7195eea8e16f57d4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:22:33 +0100
Message-ID: <1264177353.4283.1541.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 17:08 +0100, Stephane Eranian wrote:
> On Fri, Jan 22, 2010 at 4:50 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Instead of copying bitmasks around, pass pointers to the constraint structure.
> >
> The reason I changed that is because of the AMD situation where constraints
> are dynamically generated. So we need to get some storage from somwhere.
> See my AMD NB patch,

Can't we still do that by embedding 4 event_constraint structures in
struct amd_nb and rewriting those as we need?



