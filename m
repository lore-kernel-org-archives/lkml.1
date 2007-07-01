Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXGAC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXGAC52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 22:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXGAC5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 22:57:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbXGAC5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 22:57:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=EDOEJJqk0qQ2dhCdUJUtYcVD7n4ZyrMze6+Ljql6h6ymlgOAZMKJrP1n86JkNNu09
	ndP1pChl0hpzyYrecERdA==
Message-ID: <468717FF.3090401@google.com>
Date: Sat, 30 Jun 2007 22:57:03 -0400
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com> <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com> <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com> <20070626152204.b6b4bc3f.akpm@google.com> <4682A9B6.8070003@google.com> <Pine.LNX.4.64.0706271437410.31227@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706271437410.31227@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 27 Jun 2007, Ethan Solomita wrote:
> 
>> 	I looked over it at one point. Most of the code doesn't conflict, but I
>> believe that the code path which calculates the dirty limits will need
>> some merging. Doable but non-trivial.
>> 	-- Ethan
> 
> I hope you will keep on updating the patchset and posting it against 
> current mm?
> 

	I have no new changes, but I can update it against the current mm. Or
did the per-bdi throttling change get taken by Andrew?
	-- Ethan
