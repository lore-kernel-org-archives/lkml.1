Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZFBPFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZFBPFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZFBPFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:05:07 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37329 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZFBPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r1G5ffX22WcokvT1peTVyvO9uMgp7kclQdSTEilRO20ZhumQ+0wyAn4svp/czn5Lcx
         Xp5brdL7VUvtPKcLRw/N+T3fvoEbMIwr1GJTOsCfH0l8+4hKkAar8v/B9w/+bog9BbGb
         RNXTsYaQMdvh1uUbLIP94xeSXuOKuZLa7Y2LA=
MIME-Version: 1.0
In-Reply-To: <20090529184225.GE23770@alberich.amd.com>
References: <20090529184023.GD23770@alberich.amd.com>
	 <20090529184225.GE23770@alberich.amd.com>
Date: Tue, 2 Jun 2009 17:05:07 +0200
Message-ID: <36ca99e90906020805r6a4e30br6bb53aeafe5f3cd7@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: provide CPU topology information for multi-node 
	processors
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 20:42, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> This support can be switched off/on using a new config option
> MULTI_NODE_CPU. If the option is set the CPU topology information is
> extended with cpu_node information. This includes a cpu_node_id,
> cpu_node_siblings and cpu_node_siblings_list.
I think this would be a step back after commit
c50cbb05a05cf1f9ca3592272eff053c847727d8. Which exported default
topology information, in case the architecture does not provide these
information.

Regards,
Bert
>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
