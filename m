Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZLDIsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZLDIsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZLDIsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:48:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:38887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbZLDIsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:48:13 -0500
Subject: Re: [PATCH] perf events: Remove unused struct
 perf_event::event_callback
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1259882557-12024-1-git-send-regression-fweisbec@gmail.com>
References: <1259882557-12024-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 09:48:10 +0100
Message-ID: <1259916490.3977.1661.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 00:22 +0100, Frederic Weisbecker wrote:

> @@ -671,8 +671,6 @@ struct perf_event {
>  
>  	perf_callback_t			callback;

Any chance we can get all of that perf_callback_t ugly gone?


