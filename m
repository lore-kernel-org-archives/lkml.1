Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJAQWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJAQWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYJAQVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:21:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34540 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYJAQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:21:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=hpBSqiIOJzc41TXy9cAsR30JRnqZSuWiauQI6vLztGgw6snRZappHvdFk41UkEcl5
	psDbYO65Z/m5Wrsvet8gQ==
Subject: Re: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many
	thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1222792590.18031.9.camel@bobble.smo.corp.google.com>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
	 <1222114936.21579.20.camel@bobble.smo.corp.google.com>
	 <1222291416.30299.6.camel@bobble.smo.corp.google.com>
	 <20080930063313.GA23690@elte.hu>
	 <1222792590.18031.9.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 01 Oct 2008 09:20:38 -0700
Message-Id: <1222878038.29322.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 09:36 -0700, Frank Mayhar wrote:
> I'm picking up tip/master right now and will test your fix for this
> shortly.

Okay, I've put it through its paces and everything appears to be working
well with Ingo's fix.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

