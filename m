Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXJ3U2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXJ3U2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJ3U20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:28:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXJ3U2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:28:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Paul Jackson <pj@sgi.com>
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Date: Tue, 30 Oct 2007 21:27:10 +0100
User-Agent: KMail/1.9.6
Cc: Lee.Schermerhorn@hp.com, rientjes@google.com, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <200710292208.30033.ak@suse.de> <20071030124751.0a2d50b2.pj@sgi.com>
In-Reply-To: <20071030124751.0a2d50b2.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302127.10841.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 20:47:51 Paul Jackson wrote:
> Andi, Christoph, or whomever:
> 
>   Are there any good regression tests of mempolicy functionality?

numactl has some basic tests (make test). I think newer LTP 
also has some but i haven't looked at them. And there is Lee's
memtoy which does some things; but I don't think it's very automated.

-Andi
