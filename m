Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZGNVtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZGNVtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZGNVtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:49:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48194 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZGNVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:49:32 -0400
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks"
 that shows only unique tgids
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Benjamin Blum <bblum@google.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com, akpm@linux-foundation.org
In-Reply-To: <2f86c2480907141426r16f8ccf3o9770e25cc8d2e509@mail.gmail.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
	 <1247596470.13426.16088.camel@nimitz>
	 <2f86c2480907141426r16f8ccf3o9770e25cc8d2e509@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 14:49:29 -0700
Message-Id: <1247608169.13426.16602.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 14:26 -0700, Benjamin Blum wrote:
> This method looks to be a compromise between Andrew's proposed
> generalized solution ( http://lkml.org/lkml/2009/7/2/518 ) and the
> current quick-fix. The problem with it is that it'll require a layer
> between whoever's using the array and managing the list structs (for
> the case where we need to chain multiple blocks together), and if
> we're going to put forth enough effort for that, we may as well go
> ahead and write up a generalized kernel-wide library to fix this size
> problem globally.

This "Andrew" guy seems to know what he's talking about. :)

We've also got a set of pgarrs (struct page arrays) in the
checkpoint/restart code that would make use of something generic like
this.  

-- Dave

