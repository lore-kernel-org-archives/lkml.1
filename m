Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbZBEA5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbZBEA5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761481AbZBEA5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:57:11 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:59592 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbZBEA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:57:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mdNGzAUVfThZ3u7nnXmsGvM/tubyxbnyrcI8/AQQGGG2fyFPleiCXFUFILahIEo7qJ
         ThXBot1Eq+9J/AiCv2usDU3wmqS1VzLXEzUEv36xnPQpNiM1DeY8uruYAWrI/Uo8X9DL
         l1m8FQMa6G8J/hxspuc/il+Fa2SmGl1Cc4gT4=
MIME-Version: 1.0
In-Reply-To: <20090203214609.39c9c6b2.akpm@linux-foundation.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	 <20090202205545.4e1a32ea.akpm@linux-foundation.org>
	 <20090203161648.361a924a@infradead.org>
	 <20090203214609.39c9c6b2.akpm@linux-foundation.org>
Date: Wed, 4 Feb 2009 16:57:05 -0800
X-Google-Sender-Auth: 044bb7429362dd64
Message-ID: <eada2a070902041657r56bdabear46fdf1ce61edd574@mail.gmail.com>
Subject: Re: Negative values in /proc/latency_stats
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 4:16 PM, Arjan van de Ven <arjan@infradead.org> wrote:

> + * Latency Top version : v0.1
> + * 70 59433 4897 i915_irq_wait drm_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl
> + * |    |    |    |
> + * |    |    |    +----> the stringified backtrace
> + * |    |    +---------> The maximum latency for this entry in microseconds
> + * |    +--------------> The accumulated latency for this entry (microseconds)
> + * +-------------------> The number of times this entry is hit
> + *
> + * (note: the average latency is the acummulated latency deviced by the number
> + * of times)

Perhaps:

     s/acummulated/accumulated
     s/deviced/divided

...jet lag?  :)




Tim
