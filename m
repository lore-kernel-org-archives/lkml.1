Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbXEYQDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbXEYQDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXEYQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:03:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:60738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXEYQDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:03:05 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Multiple free during oprofile unload
Date: Fri, 25 May 2007 17:42:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
References: <4656FA04.5000403@redhat.com>
In-Reply-To: <4656FA04.5000403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251742.35692.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>         for_each_possible_cpu(i) {
>                 kfree(cpu_msrs[i].counters);
>                 cpu_msrs[i].counters = NULL;
>                 kfree(cpu_msrs[i].controls);
>                 cpu_msrs[i].controls = NULL;
>         }
> 
> Seems the patch makes all the cpu_msrs[] point to the same area?

Yes I forgot to fix the free path. Will submit a patch.

BTW that is why I'm not so happy with you being so trigger happy with stable
submissions.

-Andi



> 


