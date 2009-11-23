Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZKWQri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZKWQri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZKWQrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:47:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:32806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZKWQrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:47:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hfLpm1mSmAjs4dKEoHroVMdTjiv2TBoUHx34FMseEnN0k2ZPFp73+JB+UCu9pat9S
	Clw9ndFRbd75kB27ss6OA==
MIME-Version: 1.0
In-Reply-To: <1258994780.4531.682.camel@laptop>
References: <4b0ab8b1.1c07d00a.4859.5f71@mx.google.com>
	 <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
	 <1258994780.4531.682.camel@laptop>
Date: Mon, 23 Nov 2009 17:47:38 +0100
Message-ID: <bd4cb8900911230847m3f71020dy6f30885a44155e9a@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus copy_to_user() in 
	perf_event_read_group()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, eranian@gmail.com, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 5:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-11-23 at 17:36 +0100, Stephane Eranian wrote:
>>        When using an event group, the value and id for non leaders events were
>>        wrong due to invalid offset into the outgoing buffer.
>>
>>        Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Gah, I only just wrecked that didn't I...
>
Probably because it worked before.

> Thanks for catching that.
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
