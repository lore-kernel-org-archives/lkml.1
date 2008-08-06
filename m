Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbYHFDXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbYHFDXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYHFDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:23:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbYHFDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:22:58 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 8] x86/smp function calls: convert x86 tlb flushes to use function calls
From: Andi Kleen <andi@firstfloor.org>
References: <patchbomb.1217636085@localhost>
Date: Wed, 06 Aug 2008 05:22:56 +0200
In-Reply-To: <patchbomb.1217636085@localhost> (Jeremy Fitzhardinge's message of "Fri, 01 Aug 2008 17:14:45 -0700")
Message-ID: <87k5eu6d4f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> 1. use smp_call_function_mask to implement cross-cpu TLB flushes


Do you have any measurements comparing performance of the old and 
the new call? TLB flush is quite time critical so we should be very
careful here.

-Andi
