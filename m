Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0BDPEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:04:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0BDPEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:04:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=byDLckf2IN8zTW15sumL7PDTZdEOEar7Oeq480edcTI+eam4vrNMP2jgKw48vVja3
	H8tQNR0XBlIkyiCCFUH5g==
MIME-Version: 1.0
In-Reply-To: <1265295545.24455.2270.camel@laptop>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
	 <1265295545.24455.2270.camel@laptop>
Date: Thu, 4 Feb 2010 16:04:17 +0100
Message-ID: <bd4cb8901002040704vcd2d8feo82e2e1c166a02669@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 3:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, 2010-02-04 at 15:55 +0100, Peter Zijlstra wrote:
> > > +     if (boot_cpu_data.x86_max_cores < 2)
> > > +             return;
> >
> > So there are no single core AMD chips that have a NorthBridge PMU? What
> > about the recent 64bit single core laptop chips?
>
> D'0h, for those there is no need to create inter-cpu constraints.
>
Exactly!


--
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
