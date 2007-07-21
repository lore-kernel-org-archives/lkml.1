Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXGUSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXGUSZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXGUSZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:25:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:36468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbXGUSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:25:39 -0400
From: Andi Kleen <ak@suse.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Date: Sat, 21 Jul 2007 20:24:33 +0200
User-Agent: KMail/1.9.1
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, "Greg KH" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com> <200707211841.39339.ak@suse.de> <6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
In-Reply-To: <6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707212024.33627.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 20:11, Michal Piotrowski wrote:

> I confirm that the bug is fixed.

Some string functions were optimized away. When I discovered it 
I was astonished the kernel booted at all. Anyways, it could explain
a number of weird effects.

-Andi
