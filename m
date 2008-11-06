Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYKFVzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYKFVzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYKFVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:55:12 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:41099 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYKFVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:55:11 -0500
Date: Thu, 6 Nov 2008 15:53:57 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Frank Mayhar <fmayhar@google.com>,
       Doug Chapman <doug.chapman@hp.com>, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] revert: timers: fix itimer/many thread hang
In-Reply-To: <20081106214434.GA5999@elte.hu>
Message-ID: <Pine.LNX.4.64.0811061552590.14566@quilx.com>
References: <1224694989.8431.23.camel@oberon> <1225132746.14792.13.camel@bobble.smo.corp.google.com>
 <1225219114.24204.37.camel@oberon> <1225936715.27507.44.camel@bobble.smo.corp.google.com>
 <1225969420.7803.4366.camel@twins> <1225989102.7803.4749.camel@twins>
 <20081106214434.GA5999@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Ingo Molnar wrote:

> That loop could _perhaps_ be avoided by maintaining the sums from the
> scheduler tick: by just adding the latest delta values for the current
> task to times->*time. Plus at exit time cleaning up the remaining
> delta. That would be a far smaller patch.

That is a similar scheme to the ZVC (see mm/vmstat.c). Peter: Dont you
have an implementation of a ZVC like scheme for you dirty throttling
patchset that may be useful here?

