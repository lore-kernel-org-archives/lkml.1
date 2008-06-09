Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbYFIXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbYFIXdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYFIXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:33:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:22690 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYFIXdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Wehk69ZzJzWrUbCnu/+Q8s7cQ5h2v6gKejRsdru2CIzKh3lOzSCC0v1YllbBsJLzi3
         kKNatO+3fBoncrrAN8uKOzNuczA5tRcWt5/2iLlape9x+nszrlTANh3fpxzTG+YU5TLC
         NV9aUULNimKOTVaN58esFw+HvJzcqL8uA+CeI=
Date: Tue, 10 Jun 2008 01:33:21 +0200
From: dcg <diegocg@gmail.com>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 18/21] perfmon2 minimal:  X86 32-bit system calls
 support
Message-ID: <20080610013321.727c1f02@diego-desktop>
In-Reply-To: <484db00c.0405560a.4d57.6e9b@mx.google.com>
References: <484db00c.0405560a.4d57.6e9b@mx.google.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 09 Jun 2008 15:34:52 -0700 (PDT), eranian@googlemail.com escribió:

> +	.long sys_pfm_create_context
> +	.long sys_pfm_write_pmcs
> +	.long sys_pfm_write_pmds
> +	.long sys_pfm_read_pmds		/* 330 */
> +	.long sys_pfm_load_context
> +	.long sys_pfm_start
> +	.long sys_pfm_stop
> +	.long sys_ni_syscall		/* reserved for pfm_restart */
> +	.long sys_ni_syscall		/* 335 reserverd for pfm_create_evtsets */
> +	.long sys_ni_syscall		/* reserved for pfm_getinfo_evtsets */
> +	.long sys_ni_syscall		/* reserved for pfm_delete_evtsets */
> +	.long sys_pfm_unload_context

12 syscalls? O_o

I'm nobody to say if it's right or wrong...(and it probably has been
already discussed) but I'm curious, why this interface and not something
like ioctls (which many people doesn't like, but seems a better choice
for clueless people like me)?
