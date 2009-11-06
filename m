Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZKFQv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZKFQv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbZKFQv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:51:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759442AbZKFQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:51:28 -0500
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast string.
From: Andi Kleen <andi@firstfloor.org>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
Date: Fri, 06 Nov 2009 17:51:28 +0100
In-Reply-To: <1257500482-16182-1-git-send-email-ling.ma@intel.com> (ling ma's message of "Fri,  6 Nov 2009 17:41:22 +0800")
Message-ID: <87my2z7g1b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ling.ma@intel.com writes:

> Intel Nehalem improves the performance of REP strings significantly
> over previous microarchitectures in several ways:

The problem is that it's not necessarily a win on older CPUs to
do it this way.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
