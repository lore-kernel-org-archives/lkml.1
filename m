Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZANVEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZANVEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZANVEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:04:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:45482 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZANVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XWMLoO4ItS//rA7pmqrw4bPtJOo1yNi1vpxuWaIZ4jrrgKWwtfRtvIvdIyvpGVunBv
         DB4tGEAhY7afLvu7siER4CimTb9Yl9q4wdbg3m4I8HbFul6g75g9nYNsS84cEG2j8gMV
         XRWFVM/yzceo5y3pMt9Qfa4N+tDRoxdK2odq4=
Subject: Re: [patch 1/5] x86: headers cleanup - boot.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
In-Reply-To: <496e4e23.1358560a.0b42.ffff8588@mx.google.com>
References: <20090114203745.285473388@gmail.com> >
	  <496e4e23.1358560a.0b42.ffff8588@mx.google.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 13:04:40 -0800
Message-Id: <1231967080.5756.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 23:37 +0300, Cyrill Gorcunov wrote:
> -#if (defined CONFIG_KERNEL_BZIP2)
> +#ifdef CONFIG_KERNEL_BZIP2
>  #define BOOT_HEAP_SIZE             0x400000
> -#else
> +#else /* !CONFIG_KERNEL_BZIP2 */

Curious, I haven't seen the #else comments with the extra ! before,
is that something that's coming into common use?

Harvey

