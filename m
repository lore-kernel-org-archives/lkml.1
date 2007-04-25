Return-Path: <linux-kernel-owner+w=401wt.eu-S2992440AbXDYJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992440AbXDYJbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992458AbXDYJbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:31:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:55073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992440AbXDYJbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:31:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] syctl for selecting global zonelist[] order
Date: Wed, 25 Apr 2007 11:31:13 +0200
User-Agent: KMail/1.9.6
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       GOTO <y-goto@jp.fujitsu.com>
References: <20070425121946.9eb27a79.kamezawa.hiroyu@jp.fujitsu.com> <20070425004214.e21da2d8.akpm@linux-foundation.org>
In-Reply-To: <20070425004214.e21da2d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251131.13770.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> hm.  Why don't we use that ordering all the time?  Does the present ordering have
> any advantage?

At least on x86-64 it would make sense to change this always

-Andi
