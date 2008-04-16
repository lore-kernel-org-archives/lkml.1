Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYDPW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYDPW74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYDPW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:59:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:1961 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYDPW7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T3hvlKPh6xArgnM5FSLyAOWNj79b1woLIEj99biPqaremwyWG+cAPYWrLFqUKbduWdpnInO7lkffMJ195u+EQMHyMKMWZqEyAvcGr76i2kY++vk0DaytlqUqwCk33qHiB/RmsUZf2dqhX9J48TGHr43LyXoBQP/kBF1yASE8HD4=
Message-ID: <7c86c4470804161559y1f2e1e51y9447d5b15148d5f6@mail.gmail.com>
Date: Thu, 17 Apr 2008 00:59:45 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 1/1] x86, ptrace: PEBS support
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Markus Metzger" <markus.t.metzger@intel.com>, andi-suse@firstfloor.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       roland@redhat.com, mtk.manpages@gmail.com, juan.villacis@intel.com
In-Reply-To: <20080416144723.GI24383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408110158.A9336@sedona.ch.intel.com>
	 <20080415173534.b746f8da.akpm@linux-foundation.org>
	 <20080416144723.GI24383@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On Wed, Apr 16, 2008 at 4:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>  > Should we skip the RLIMIT_MEMLOCK check if capable(CAP_IPC_LOCK)?
>  >
>  > It's a fairly large patch.
>
>  btw., it's already in x86/testing (has been since last week) and hence
>  it's in linux-next as well.
>
Does this include the PEBS support?
