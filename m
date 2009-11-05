Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbZKETox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbZKETox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZKETow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:44:52 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:35493 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758813AbZKETow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:44:52 -0500
Date: Thu, 5 Nov 2009 10:04:55 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Dave Jones <davej@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
In-Reply-To: <20091104234923.GA25306@redhat.com>
Message-ID: <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> <20091104234923.GA25306@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Dave Jones wrote:

> On Wed, Nov 04, 2009 at 02:14:41PM -0500, Christoph Lameter wrote:
>
>  > +		memset(m, sizeof(struct mm_counter), 0);
>
> Args wrong way around.

Right. It works because percpu_alloc zeroes the data anyways.

