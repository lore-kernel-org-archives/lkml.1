Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYCREIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYCREIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYCREIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:08:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46731 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbYCREIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:08:31 -0400
Date: Mon, 17 Mar 2008 21:07:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205810884.3215.543.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803172105520.17771@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang> 
 <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com> 
 <1205479398.3215.284.camel@ymzhang>  <Pine.LNX.4.64.0803141400170.28115@schroedinger.engr.sgi.com>
  <1205740204.3215.520.camel@ymzhang>  <Pine.LNX.4.64.0803171027450.7359@schroedinger.engr.sgi.com>
 <1205810884.3215.543.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Zhang, Yanmin wrote:

> num_online_cpus as the input parameter is ok. A potential issue is how to consider cpu hot-plug.

Yeah I used nr_cpu_ids instead in the patchset that I cced you on. Maybe 
continue discussion on that thread?

