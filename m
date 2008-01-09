Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYAITyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYAITyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYAITym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:54:42 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33411 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYAITyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:54:41 -0500
Subject: Re: [PATCH 10/10] x86: Unify percpu.h
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <Pine.LNX.4.64.0801091130420.11317@schroedinger.engr.sgi.com>
References: <20080108211023.923047000@sgi.com>
	 <20080108211025.293924000@sgi.com> <1199906905.9834.101.camel@localhost>
	 <Pine.LNX.4.64.0801091130420.11317@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 11:53:50 -0800
Message-Id: <1199908430.9834.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 11:31 -0800, Christoph Lameter wrote:
> Well this is only the first patchset. The next one will unify this even 
> more (and make percpu functions work consistent between the two arches) 
> but it requires changes to the way the %gs register is used in 
> x86_64. So we only do the simplest thing here to have one file to patch 
> against later.

Then I really think this particular patch belongs in that other patch
set.  Here, it makes very little sense, and it's on the end anyway.

-- Dave

