Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbYCEMXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbYCEMXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbYCEMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:23:21 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44343 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756458AbYCEMXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:23:20 -0500
Date: Wed, 5 Mar 2008 06:23:18 -0600
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/2] Cpuset hardwall flag:  Introduction
Message-Id: <20080305062318.3c7538c3.pj@sgi.com>
In-Reply-To: <20080305075237.608599000@menage.corp.google.com>
References: <20080305075237.608599000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Currently the cpusets mem_exclusive flag is overloaded to mean both
> "no-overlapping" and "no GFP_KERNEL allocations outside this cpuset".
> 
> These patches add a new mem_hardwall flag with just the allocation
> restriction part of the mem_exclusive semantics, without breaking
> backwards-compatibility for those who continue to use just
> mem_exclusive.

... too bad this nice comment wasn't included in PATCH 2/2, so that
it would automatically make it into the record of history - the source
control log message (as best I understand how Andrew's tools work,
comments off in their own, codeless patch "PATCH 0/N" don't make
it to the source control log, except when Andrew chooses to make a
special effort.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
