Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYACSn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYACSn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYACSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:43:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:42650 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYACSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:43:49 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] [1/8] GBPAGES: Handle kernel near memory hole in clear_kernel_mapping
Date: Thu, 3 Jan 2008 19:43:05 +0100
User-Agent: KMail/1.9.6
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20080103626.635376000@suse.de> <20080103172657.B5CFA14DDD@wotan.suse.de> <20080103182928.GC3028@redhat.com>
In-Reply-To: <20080103182928.GC3028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031943.05688.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Got a question. How will kernel continue to run if we unmap the kernel
> text/data region mappings?

Normally it shouldn't be in the same 2MB area as the aperture (which
is the only thing that is unmapped). The problem is mostly
the rest of the 40MB kernel mapping.

-Andi

