Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYHLHLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYHLHLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYHLHLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:11:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43906 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYHLHLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:11:11 -0400
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
From: Andi Kleen <andi@firstfloor.org>
References: <48A086B6.2000901@linux-foundation.org>
	<20080811.141501.01468546.davem@davemloft.net>
	<48A0B037.501@linux-foundation.org>
Date: Tue, 12 Aug 2008 09:11:08 +0200
In-Reply-To: <48A0B037.501@linux-foundation.org> (Christoph Lameter's message of "Mon, 11 Aug 2008 16:33:43 -0500")
Message-ID: <87r68u1zeb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> Maybe what we are seeing is general bloat in kernel execution paths
> due to the growth in complexity?

Wouldn't surprise me. Have you considered doing profiles? 

e.g. just oprofiling the benchmark on the different kernels and see
if there's some obvious difference in the CPU consumers? 

-Andi
