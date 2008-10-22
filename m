Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYJVRvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYJVRvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbYJVRr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:47:28 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:53113 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937AbYJVRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:47:27 -0400
Date: Wed, 22 Oct 2008 10:47:09 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
In-Reply-To: <20081022172103.GJ9639@localhost>
Message-ID: <Pine.LNX.4.64.0810221037320.7633@quilx.com>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com>
 <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost>
 <20081022172103.GJ9639@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:

> Christoph how about this one?

Ok. Looks a bit better but we still have two maxes here

s->max which refers to the maximum number of objects per slab page for 
a specific slab cache (depends on the runtime configuration). OO_MAX_OBJS 
refers to the maximum number of objects per slab page that any slab cache 
can be configured for which is a compile time limit.

Maybe this is okay, Pekka?

