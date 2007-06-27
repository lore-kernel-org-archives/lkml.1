Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXF0SSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXF0SSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbXF0SRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:17:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbXF0SRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:17:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=JxEqLh7xccAdwSPnQitPt56p6wsBdZh3ObpGQ2EbACEdEtSLG/Ou69p414NyJAIUR
	XF7utNjWdPCHmQ/lWvXfw==
Message-ID: <4682A9B6.8070003@google.com>
Date: Wed, 27 Jun 2007 14:17:26 -0400
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@google.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com>	<Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>	<46646A33.6090107@google.com>	<Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>	<468023CA.2090401@google.com>	<Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com> <20070626152204.b6b4bc3f.akpm@google.com>
In-Reply-To: <20070626152204.b6b4bc3f.akpm@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> One open question is the interaction between these changes and with Peter's
> per-device-dirty-throttling changes.  They also are in my queue somewhere. 

	I looked over it at one point. Most of the code doesn't conflict, but I
believe that the code path which calculates the dirty limits will need
some merging. Doable but non-trivial.
	-- Ethan
