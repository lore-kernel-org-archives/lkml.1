Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZKVWoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZKVWoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 17:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZKVWox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 17:44:53 -0500
Received: from ozlabs.org ([203.10.76.45]:43525 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZKVWox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 17:44:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19209.48577.356560.738625@cargo.ozlabs.ibm.com>
Date: Mon, 23 Nov 2009 09:40:01 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
In-Reply-To: <20091122113942.GD13644@redhat.com>
References: <20091029152002.GA5406@redhat.com>
	<20091104110604.GE13194@elte.hu>
	<20091117092331.GA23585@elte.hu>
	<20091122112726.GC13644@redhat.com>
	<20091122113942.GD13644@redhat.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin writes:

> Btw, why is it a good idea to force 64/32 bit mode?
> Why not use the default gcc mode?

On powerpc the gcc default is often 32-bit even when running under a
64-bit kernel, but we want to build perf 64-bit if possible.

Paul.
