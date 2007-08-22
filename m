Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXHVSoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXHVSoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762873AbXHVSoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:44:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41510 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761478AbXHVSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:44:17 -0400
Date: Wed, 22 Aug 2007 11:44:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: lkml <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH][BUGFIX] fix rcu_read_lock in page migraton
In-Reply-To: <20070822140058.29677634.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0708221143440.13813@schroedinger.engr.sgi.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
 <20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
 <1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
 <20070822140058.29677634.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, KAMEZAWA Hiroyuki wrote:

> This is a patch against the problme Shaohua rported.
> Just an idea for fix the problem.
> How do you think ? dummy vma is better ? (I don't like dummy vma.)

Yup but we have to do it.

Acked-by: Christoph Lameter <clameter@sgi.com>

