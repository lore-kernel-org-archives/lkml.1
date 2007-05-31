Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXEaAak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXEaAak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbXEaAaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:30:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60132 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824AbXEaAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:30:14 -0400
Message-Id: <20070531002047.702473071@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 17:20:47 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [RFC 0/4] CONFIG_STABLE to switch off development checks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A while back we talked about having the capability of switching off checks
like the one for kmalloc(0) for stable kernel releases. This is a first stab
at such functionality. It adds #ifdef CONFIG_STABLE for now. Maybe we can
come up with some better way to handle it later. There should alsol be some
way to set CONFIG_STABLE from the Makefile.

CONFIG_STABLE switches off

- kmalloc(0) check in both slab allocators
- SLUB banner
- Makes SLUB tolerate object corruption like SLAB (not sure if we really want
  to go down this route. See patch)

-- 
