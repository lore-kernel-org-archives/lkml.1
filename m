Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbZATUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbZATUuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbZATUty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:49:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:3071 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbZATUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:49:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kjQ1RzA4KT6xb0cWMg9qJgVPv5PHLn1Jc/9n8F+775tLWz0/ANaU0GpvaP9CUBW3GF
         aFPs2UCFEo6ANPJhSkm+GptajA27OX22tVJrQm+iITEcVmbazqEE9VzSwGsHGh+zMV9n
         MOMi1dsGcl8TzF9bkazqfQknXJVFzRw9F8XRM=
MIME-Version: 1.0
In-Reply-To: <49763718.7010501@kernel.org>
References: <49763718.7010501@kernel.org>
Date: Tue, 20 Jan 2009 12:49:53 -0800
X-Google-Sender-Auth: 6f26c02cb23c46ba
Message-ID: <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory 
	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> with the config
>
> current tip said:
>
>  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> c14d2186 00920e01   R_386_32 c1514000  __per_cpu_load
>
and will casue system reboot after

[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu dat

YH
