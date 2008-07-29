Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYG2CMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYG2CMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYG2CMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:12:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYG2CMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:12:24 -0400
Date: Tue, 29 Jul 2008 04:12:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Message-ID: <20080729021215.GG30344@one.firstfloor.org>
References: <488E534F.2030204@goop.org> <488E5455.6010901@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E5455.6010901@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:20:53PM -0700, Jeremy Fitzhardinge wrote:
> Resend to cc: Andi on an address which actually works.
> 
> Jeremy Fitzhardinge wrote:
> >Now that normal smp_function_call is no longer an enormous bottleneck, 

Hmm? It still uses a global lock at least as of current git tree.

-Andi
