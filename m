Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbXJCS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbXJCS3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXJCS3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:29:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbXJCS3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:29:10 -0400
Date: Wed, 3 Oct 2007 11:28:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
In-Reply-To: <4703DD8A.80602@linux.intel.com>
Message-ID: <alpine.LFD.0.999.0710031125100.3579@woody.linux-foundation.org>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
 <20071002150748.906970bc.akpm@linux-foundation.org> <4702C756.8090108@redhat.com>
 <20071002162613.54c3ef43@laptopd505.fenrus.org> <4703D212.6040304@redhat.com>
 <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
 <4703DD8A.80602@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Arjan van de Ven wrote:
> 
> not sure this is going to help; I mean, the load gets only updated in actual
> timer interrupts... and on a tickless system there's very few of those
> around..... and usually at places round_jiffies() already put a timer on.

Yeah, you're right. Although in practice, at least on a system running 
X, I'd expect that there still is lots of other timers going on, hiding 
the issue.

Hmm. Maybe Anders' problem stems partly from the fact that he really is 
using the tweaks to make that tickless theory more true than it tends to 
be on most systems?

		Linus
