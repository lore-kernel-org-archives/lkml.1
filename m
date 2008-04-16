Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYDPSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYDPSBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYDPSBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:01:05 -0400
Received: from oss.sgi.com ([192.48.170.157]:35306 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYDPSBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:01:04 -0400
Date: Wed, 16 Apr 2008 19:00:59 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-mips@linux-mips.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] MIPS: irixelf: fix test unsigned var < 0
Message-ID: <20080416180059.GC32263@linux-mips.org>
References: <480558CA.7090800@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480558CA.7090800@tiscali.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 03:39:22AM +0200, Roel Kluin wrote:

> v is unsigned, cast to signed to evaluate the do_brk() return value,

do_brk() is expected to return its first argument as the result in case
of success.  An error also wasn't getting propagated so some further
fixes were needed for irix_map_prda_page and its caller.  So I'll apply
a different fix.

Thanks!

  Ralf
