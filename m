Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYJVSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYJVSq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYJVSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:46:21 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:39620 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYJVSqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:46:20 -0400
Date: Wed, 22 Oct 2008 11:45:55 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
In-Reply-To: <20081022183055.GN9639@localhost>
Message-ID: <Pine.LNX.4.64.0810221144290.6054@quilx.com>
References: <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost>
 <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost>
 <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi>
 <20081022175827.GL9639@localhost> <Pine.LNX.4.64.0810221110060.27088@quilx.com>
 <20081022181556.GM9639@localhost> <Pine.LNX.4.64.0810221123150.17454@quilx.com>
 <20081022183055.GN9639@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:

> Looks really good for me (if it worth anything). But Christoph
> doesn't OO_SHIT inspired by u16 too which means we could use
> MAX_OBJ_PER_PAGE in form you mentoined but maybe we should define
>
> #define OO_SHIFT bits_in(page.objects) to point out why we use
> 16 not 14, not 18 or whatever? How do you think?


The choice of the bit size in page.objects is determined by the available 
bytes there. The choice of the OO_SHIFT (nice typo there) is determined by 
the use of a 32bit int that we want to cut into two halves.

