Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZETSnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZETSnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZETSnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:43:24 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4718 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbZETSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:43:23 -0400
Subject: Re: [PATCH] mm/slub.c: Use print_hex_dump and remove unnecessary
 cast
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       H Hartley Sweeten <hartleys@visionengravers.com>, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <alpine.DEB.1.10.0905201420050.17511@qirst.com>
References: <1242840314-25635-1-git-send-email-joe@perches.com>
	 <alpine.DEB.1.10.0905201420050.17511@qirst.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 11:42:46 -0700
Message-Id: <1242844966.22786.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 14:23 -0400, Christoph Lameter wrote:
> This was discussed before.
> http://lkml.indiana.edu/hypermail/linux/kernel/0705.3/2671.html

You've got a good memory.

> Was hexdump changed?

It seems not.

> How does the output look after this change?

>From reading the code, the last column is unaligned.

I did submit a patch to fix hexdump once.
http://lkml.org/lkml/2007/12/6/304


