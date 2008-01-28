Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYA1SpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYA1SpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYA1SpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:45:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46025 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbYA1SpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:45:04 -0500
Date: Mon, 28 Jan 2008 10:44:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/4] mmu_notifier: Core code
In-Reply-To: <20080126120149.GS3058@sgi.com>
Message-ID: <Pine.LNX.4.64.0801281044380.14003@schroedinger.engr.sgi.com>
References: <20080125055606.102986685@sgi.com> <20080125055801.212744875@sgi.com>
 <20080125183934.GO26420@sgi.com> <Pine.LNX.4.64.0801251041040.672@schroedinger.engr.sgi.com>
 <20080125185646.GQ3058@sgi.com> <Pine.LNX.4.64.0801251058170.3198@schroedinger.engr.sgi.com>
 <20080125193554.GP26420@sgi.com> <Pine.LNX.4.64.0801251315350.19523@schroedinger.engr.sgi.com>
 <20080126120149.GS3058@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Robin Holt wrote:

> But what if the caller is already holding the mmap_sem?  Why force the
> acquire into this function?  Since we are dealing with a semaphore/mutex,

Then you need to call __register_mmu_notifier.
