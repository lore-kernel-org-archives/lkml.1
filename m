Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYFIXaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYFIXaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYFIXa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:30:27 -0400
Received: from gw.goop.org ([64.81.55.164]:56625 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYFIXa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:30:26 -0400
Message-ID: <484DBCE7.9030008@goop.org>
Date: Tue, 10 Jun 2008 00:29:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with x86_xx_percpu().
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu> <484D6A05.7010508@sgi.com> <Pine.LNX.4.64.0806091119150.30592@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806091119150.30592@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Paravirt support is on. We have seen an issue with that in the past. Why 
> was that again?
>   

I'm not aware of any paravirt-related percpu bugs (other than the fact 
that the last major revision of per-cpu variables was done under the 
aegis of paravirt-ops).

But booting on bare hardware with pvops enabled should be exactly the 
same as non-pvops with respect to percpu.

    J
