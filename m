Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0CCVOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:14:33 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:48497 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0CCVO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WFLd3tVA+3QM3STsJ8Z1g4ufGUVcfrrNKZ3R1Iymg+qsfavtZpaUYQL+On9kithsXz
         hlQbDaWuU6g81fodbVqcOByl+3/KMwJasPVMd1WZld82HqrYCkRMa2pue2mVvSPPZ6DI
         INCg+dt7Gb4u+cdgE2MGFqQYBPot+xQ3eskZc=
Date: Wed, 3 Mar 2010 22:14:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com,
       Jamie Iles <jamie.iles@picochip.com>, Jean Pihet <jpihet@mvista.com>,
       "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: Re: [RFC][PATCH 05/11] perf: Generic perf_sample_data
	initialization
Message-ID: <20100303211419.GE5194@nowhere>
References: <20100303163936.906011640@chello.nl> <20100303164306.222595079@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303164306.222595079@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 05:39:41PM +0100, Peter Zijlstra wrote:
> This makes it easier to extend perf_sample_data and fixes a bug on
> arm and sparc, which failed to set ->raw to NULL, which can cause
> crashes when combined with PERF_SAMPLE_RAW.
> 
> It also optimizes PowerPC and tracepoint, because the struct
> initialization is forced to zero out the whole structure.
> 
> CC: Jamie Iles <jamie.iles@picochip.com>
> CC: Jean Pihet <jpihet@mvista.com>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: David S. Miller <davem@davemloft.net>
> CC: Stephane Eranian <eranian@google.com>

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

