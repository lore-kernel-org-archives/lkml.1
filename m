Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797Ab0AUR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0AUR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951Ab0AUR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:59:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0AUR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:59:19 -0500
Date: Thu, 21 Jan 2010 18:59:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, andi@firstfloor.org,
       david@fromorbit.com, dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100121175914.GA8910@basil.fritz.box>
References: <87fx609i29.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fx609i29.fsf@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 08:51:26PM -0800, Don Mullis wrote:
> The use of list_sort() by UBIFS looks like it could generate long
> lists; this alternative implementation scales better, reaching ~3x
> performance gain as list length approaches the L2 cache size.

If this can really be called with long lists 
the function likely needs (optional) need_resched()s
Otherwise it could ruin scheduling latencies.

-Andi
