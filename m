Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYAIULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYAIULZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYAIULR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:11:17 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35631 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701AbYAIULQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:11:16 -0500
Date: Wed, 9 Jan 2008 12:11:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH 10/10] x86: Unify percpu.h
In-Reply-To: <1199908430.9834.104.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801091210300.11709@schroedinger.engr.sgi.com>
References: <20080108211023.923047000@sgi.com>  <20080108211025.293924000@sgi.com>
 <1199906905.9834.101.camel@localhost>  <Pine.LNX.4.64.0801091130420.11317@schroedinger.engr.sgi.com>
 <1199908430.9834.104.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Dave Hansen wrote:

> Then I really think this particular patch belongs in that other patch
> set.  Here, it makes very little sense, and it's on the end anyway.

It makes sense in that both percpu_32/64 are very small as a result of 
earlier patches and so its justifiable to put them together to simplify 
the next patchset.

