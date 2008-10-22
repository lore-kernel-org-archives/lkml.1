Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYJVVDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYJVVDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYJVVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:03:37 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:56439 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJVVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:03:36 -0400
Date: Wed, 22 Oct 2008 14:01:28 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Miklos Szeredi <miklos@szeredi.hu>, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810221400340.26671@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop> 
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>  <48FE6306.6020806@linux-foundation.org>
  <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810220822500.30851@quilx.com>
  <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221252570.3562@quilx.com>
  <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221315080.26671@quilx.com>
  <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu> <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Pekka Enberg wrote:

> Actually, when debugging is enabled, it's customary to poison the
> object, for example (see free_debug_processing() in mm/slub.c). So we
> really can't "easily ensure" that in the allocator unless we by-pass
> all the current debugging code.

We may be talking of different frees here. Maybe what he means by freeing 
is that the object was put on the lru? And we understand a kfree().
