Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYJWNm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYJWNm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbYJWNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:42:12 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:34413 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYJWNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:42:11 -0400
Date: Thu, 23 Oct 2008 06:40:43 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Miklos Szeredi <miklos@szeredi.hu>
cc: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0810230638450.11924@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop> 
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>  <48FE6306.6020806@linux-foundation.org>
  <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810220822500.30851@quilx.com>
  <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221252570.3562@quilx.com>
  <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221315080.26671@quilx.com>
  <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>  <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
  <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221416130.26639@quilx.com>
  <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu> <1224745831.25814.21.camel@penberg-laptop>
 <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Miklos Szeredi wrote:

> I think the _real_ problem is that instead of fancy features like this
> defragmenter, SLUB should first concentrate on getting the code solid
> enough to replace the other allocators.

Solid? What is not solid? The SLUB design was made in part because of the 
defrag problems that were not easy to solve with SLAB. The ability to lock 
down a slab allows stabilizing objects. We discussed solutions to the 
fragmentation problem for years and did not get anywhere with SLAB.


