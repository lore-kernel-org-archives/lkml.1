Return-Path: <linux-kernel-owner+w=401wt.eu-S936198AbZDIS42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936198AbZDIS42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760361AbZDIS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:56:10 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:62735 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758917AbZDIS4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:56:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAEABfi3UlMQW1W/2dsb2JhbACBUpMpuW+DewY
Date: Thu, 9 Apr 2009 14:56:06 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: =?utf-8?B?5pu+54+K?= <zengshan227@gmail.com>,
       pierre-marc.fournier@polymtl.ca
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: LTTng 0.115 for Linux 2.6.29
Message-ID: <20090409185606.GB4252@Krystal>
References: <20090324031446.GA9515@Krystal> <9f49f7820904090734i1c7b727u61f235fd9ed162a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <9f49f7820904090734i1c7b727u61f235fd9ed162a2@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:53:37 up 40 days, 15:19,  1 user,  load average: 0.37, 0.37,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* 曾珊 (zengshan227@gmail.com) wrote:
> can ltt been used in network IO tracing under the environment of KVM?
> 
> hi:
>   what I meant path tracing is that we want to get the ingressing path of a
> packet under the environment of KVM (Kernel based Virtual Machine ), what we
> want to know exactly is the ingressing path of a packet from the host
> machine to the virtual machine ,
> ps: KVM used Qemu to process its network I/O , which is actually a process
> in the host OS.
>   Any ideas?
>   Thank you very much~

Yes, Pierre-Marc has done some work to make sure LTTV can show traces
from both the host kernel and a virtual machine together and therefore
allow the kind of analysis you are looking for. I am putting him in CC
so he can explain how to use his work.

Mathieu

> 
> 2009/3/24 Mathieu Desnoyers <compudj@krystal.dyndns.org>
> 
> > Hi,
> >
> > I just released LTTng 0.115 for Linux 2.6.29. Happy tracing. :)
> >
> > It is, as always, available both as a patchset and as a git tree. See
> > http://www.lttng.org for details.
> >
> > Mathieu
> >
> >
> > --
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
