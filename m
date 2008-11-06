Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYKFQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYKFQJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYKFQJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:09:35 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:55502 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYKFQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:09:34 -0500
Date: Thu, 6 Nov 2008 10:08:21 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: <1225984098.7803.4642.camel@twins>
Message-ID: <Pine.LNX.4.64.0811061008030.5349@quilx.com>
References: <1224694989.8431.23.camel@oberon>  <1225132746.14792.13.camel@bobble.smo.corp.google.com>
  <1225219114.24204.37.camel@oberon>  <1225936715.27507.44.camel@bobble.smo.corp.google.com>
  <1225969420.7803.4366.camel@twins>  <Pine.LNX.4.64.0811060900450.3595@quilx.com>
 <1225984098.7803.4642.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Peter Zijlstra wrote:

> Right, but I don't think the patch under consideration will fly anyway,
> doing a for_each_possible_cpu() loop on every tick on all cpus isn't
> really healthy, even for moderate sized machines.

Correct.


