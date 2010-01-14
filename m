Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693Ab0ANJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0ANJX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642Ab0ANJXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:23:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab0ANJXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:23:51 -0500
Date: Thu, 14 Jan 2010 10:23:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Joshua Pincus <joshua.pincus@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100114092350.GF12241@basil.fritz.box>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We would like to avoid using ptrace at all costs.
> It requires us to have a parent thread running
> which monitors all the others.  It's not clear that
> the wait() call by the parent doesn't mask a barrage
> of signals from various threads and the performance

mask? It'll report them. You expect to have so 
many signals that this would be a problem?

-Andi
