Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYJVRyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYJVRyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYJVRyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:54:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59946 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbYJVRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:54:39 -0400
Message-ID: <48FF6800.20705@cs.helsinki.fi>
Date: Wed, 22 Oct 2008 20:50:56 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0810221037320.7633@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
> 
>> Christoph how about this one?
> 
> Ok. Looks a bit better but we still have two maxes here
> 
> s->max which refers to the maximum number of objects per slab page for a 
> specific slab cache (depends on the runtime configuration). OO_MAX_OBJS 
> refers to the maximum number of objects per slab page that any slab 
> cache can be configured for which is a compile time limit.
> 
> Maybe this is okay, Pekka?

Maybe call the page->objects maximum MAX_OBJS_PER_PAGE as it's not 
strictly related to the other OO code?

		Pekka
