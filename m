Return-Path: <linux-kernel-owner+w=401wt.eu-S932727Ab0AGIbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0AGIbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932660Ab0AGIbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:31:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab0AGIbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:31:08 -0500
Subject: Re: Counting FP multiplies on Core 2
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20100107045248.GB30718@drongo>
References: <20100107045248.GB30718@drongo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 09:30:33 +0100
Message-ID: <1262853033.4049.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 15:52 +1100, Paul Mackerras wrote:
> The Intel manual tells me that event num 12H, umask 00H on Core 2
> counts multiply operations executed, but says "Use IA32_PMC1 only".
> Is there a way in the raw event code to specify a particular PMC, or
> does the code just know that that event can only be counted on PMC1?

Right, this is what Stephane is trying to implement, but he's not very
fast.. maybe I should help him out.

