Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZJVA2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZJVA2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZJVA2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:28:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35651 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZJVA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:28:52 -0400
Date: Thu, 22 Oct 2009 02:28:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091022002853.GP32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256167297.4768.14.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 04:21:37PM -0700, john stultz wrote:
> 
> Taking a very raw attempt at this, I scratched out the following simple
> implementation. I'd appreciate any review or suggestions for
> improvements. I'm not at all certain the passing of the thread pid_t
> through the unsigned long is valid, for instance, or if
> same_thread_group() is the right check to make sure we only change
> siblings and not tid from other processes. So any advice on better
> approaches would be great.

First though that comes to mind is that this should not be in prctl()

-Andi
