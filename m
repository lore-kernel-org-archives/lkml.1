Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0CDI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:58:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab0CDI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:58:29 -0500
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
In-Reply-To: <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 09:58:27 +0100
Message-ID: <1267693107.25158.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 22:57 +0100, Stephane Eranian wrote:
> I don't understand how LBR state is migrated when a per-thread event is moved
> from one CPU to another. It seems LBR is managed per-cpu.
> 
> Can you explain this to me?

It is not, its basically impossible to do given that the TOS doesn't
count more bits than is strictly needed.

Or we should stop supporting cpu and task users at the same time.

