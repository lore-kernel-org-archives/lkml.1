Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYJ3PrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYJ3PrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYJ3PrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:47:10 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:35056 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYJ3PrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:47:08 -0400
Date: Thu, 30 Oct 2008 10:45:45 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <dada1@cosmosbay.com>, Miklos Szeredi <miklos@szeredi.hu>,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <1225191983.27477.16.camel@penberg-laptop>
Message-ID: <Pine.LNX.4.64.0810301044290.20953@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop> 
 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com> 
 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221416130.26639@quilx.com>
  <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>  <1224745831.25814.21.camel@penberg-laptop>
  <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810230638450.11924@quilx.com>
  <84144f020810230658o7c6b3651k2d671aab09aa71fb@mail.gmail.com> 
 <Pine.LNX.4.64.0810230705210.12497@quilx.com> 
 <84144f020810230714g7f5d36bas812ad691140ee453@mail.gmail.com> 
 <Pine.LNX.4.64.0810230721400.12497@quilx.com>  <49009575.60004@cosmosbay.com>
  <Pine.LNX.4.64.0810231035510.17638@quilx.com>  <4900A7C8.9020707@cosmosbay.com>
  <Pine.LNX.4.64.0810231145430.19239@quilx.com>  <4900B0EF.2000108@cosmosbay.com>
 <1225191983.27477.16.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Pekka Enberg wrote:

> Christoph, I was sort of expecting a NAK/ACK from you before merging
> this. I would be nice to have numbers on this but then again I don't see
> how this can hurt either.

Its an additional instruction in a hot path. Lets see some numbers first.

Try tbench. Seems to be very popular recently. Or my microbenchmarks 
for slab allocations on kernel.org.


