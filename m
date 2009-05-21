Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZEUGQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZEUGQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZEUGQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:16:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34200 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZEUGQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:16:25 -0400
Message-ID: <4A14F15C.2050503@kernel.org>
Date: Wed, 20 May 2009 23:14:52 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power	Management
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam> <20090513062748.GE9991@alberich.amd.com>
In-Reply-To: <20090513062748.GE9991@alberich.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> 
> What's the point of adding power managment flags twice?
> Most of it is already displayed in /proc/cpuinfo under
> "power management".
> 

And that is user-space visible, so even if we unify the array (which may
be worthwhile) we cannot change the way they're presented to userspace.

	-hpa

