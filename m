Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYFKVuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYFKVuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYFKVt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:49:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbYFKVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:49:55 -0400
Date: Wed, 11 Jun 2008 14:49:18 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Rafael Almeida" <almeidaraf@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fixed NetEm's reorder option
Message-ID: <20080611144918.1668e3d8@extreme>
In-Reply-To: <6de6b1650806111305m51bf2eccocbe0d0c7afee266d@mail.gmail.com>
References: <48479f6a.e203be0a.73e1.fffff59b@mx.google.com>
	<6de6b1650806111305m51bf2eccocbe0d0c7afee266d@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 17:05:10 -0300
"Rafael Almeida" <almeidaraf@gmail.com> wrote:

> I noticed no one said anything about my patch below, did I do
> something terrible wrong? Should I just be more patient?
> 
> On Thu, Jun 5, 2008 at 1:34 AM, Rafael C. de Almeida
> <almeidaraf@gmail.com> wrote:
> > The reorder option wasn't working correctly. It would only kick in if
> > the gap option was set. In that case it would only lower the
> > probability of reordering packets because of how the if conditional
> > was stated.
> >
> > This patch separetes the algorithm for reordering with gap from the
> > rest, rendering the code more readable and correct.
> >
> > Signed-off-by: Rafael C. de Almeida <rafaelc@dcc.ufmg.br>

Haven't had time to look at this in detail, and I worry about the impact
of changing assumptions people already have in their scripts.
