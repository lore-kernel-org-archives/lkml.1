Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYJVXVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYJVXVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYJVXVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:21:15 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:59717 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYJVXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:21:15 -0400
Date: Wed, 22 Oct 2008 16:20:35 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Miklos Szeredi <miklos@szeredi.hu>
cc: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0810221619310.29044@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop> 
 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>  <48FE6306.6020806@linux-foundation.org>
  <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810220822500.30851@quilx.com>
  <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221252570.3562@quilx.com>
  <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221315080.26671@quilx.com>
  <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu> <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0810221416130.26639@quilx.com>
 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Miklos Szeredi wrote:

> So again, just checking d_lru should do work fine.  There's absolutely
> no need to mess with extra references in a separate phase, which leads
> to lots of complications.

Then try it the way I outlined it by skipping the get() stage. You just 
need to add checks for the poison in case debugging is on and then you 
should be fine.

