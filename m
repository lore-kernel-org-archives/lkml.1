Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZCKQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZCKQtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZCKQtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:49:04 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42289 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbZCKQtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:49:02 -0400
Subject: Re: [PATCH 1/2] x86: make voyager_phys_cpu_present_map static
	unsigned long.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20090311064033.88201DE14D@ozlabs.org>
References: <20090311064033.88201DE14D@ozlabs.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 16:48:58 +0000
Message-Id: <1236790138.3270.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 17:02 +1030, Rusty Russell wrote:
> Impact: cleanup, remove cpumask_t
> 
> Instead of replacing voyager_phys_cpu_present_map with a cpumask_var_t,
> let's make it an unsigned long as assumed in various places anyway.
> 
> Also delete incorrect comment on external usage.

Yes, this looks good.  Having it as a cpumask_t was really a historical
artifact from the time when phys_cpu_present_map was an expected
subarchitecture export.

James


