Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYLaNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYLaNBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYLaNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:01:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:53341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYLaNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cjFWx4VSYm2rNXTHlAkNBE/CASICuzL/6sbWshO+a3XiR5cCkm9oQM15QZfu+5x3xF
         PlsTr4Rxo37rx9z6ve8G12mVBpAGc4OEsY+P0My99+LxO3iXI0XYUeod61zbXfBulBL3
         XzSqXUuXJ3aOSIpvgFuE2IHRqTNNA/rCbR0/A=
Message-ID: <84144f020812310501w4c64de85r9125cfacccc5ae97@mail.gmail.com>
Date: Wed, 31 Dec 2008 15:01:22 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jaswinder Singh Rajput" <jaswinder@infradead.org>
Subject: Re: [PATCH] x86: cpuid.c fix style problems
Cc: "Ingo Molnar" <mingo@elte.hu>, hpa@kernel.org,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1230721188.3738.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230721188.3738.2.camel@jaswinder.satnam>
X-Google-Sender-Auth: 4d5d0e6904a0c30a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 12:59 PM, Jaswinder Singh Rajput
<jaswinder@infradead.org> wrote:
>        cpu = iminor(file->f_path.dentry->d_inode);
> -       if (cpu >= NR_CPUS || !cpu_online(cpu)) {
> +       if (cpu >= num_possible_cpus() || !cpu_online(cpu)) {

How come you didn't convert the first part of the expression to use
cpu_possible()?

>                ret = -ENXIO;   /* No such CPU */
>                goto out;
>        }
