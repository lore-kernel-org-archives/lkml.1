Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXFRUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXFRUyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765001AbXFRUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:54:25 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38579
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763402AbXFRUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:54:23 -0400
Date: Mon, 18 Jun 2007 13:52:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brendan Conoboy <blc@redhat.com>
cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <4676D8DE.3050903@redhat.com>
Message-ID: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
References: <18034.479.256870.600360@notabene.brown>
 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
 <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
 <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com>
 <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Brendan Conoboy wrote:

> david@lang.hm wrote:
>>  yes, sorry, ultra 320 wide.
>
> Exactly how many channels and drives?

one channel, 2 OS drives plus the 45 drives in the array.

yes I realize that there will be bottlenecks with this, the large capacity 
is to handle longer history (it's going to be a 30TB circular buffer being 
fed by a pair of OC-12 links)

it appears that my big mistake was not understanding what /proc/mdstat is 
telling me.

David Lang
