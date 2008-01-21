Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYAULRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYAULRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 06:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYAULRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 06:17:06 -0500
Received: from ozlabs.org ([203.10.76.45]:37327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbYAULRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 06:17:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Denis Cheng <crquan@gmail.com>
Subject: Re: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Date: Mon, 21 Jan 2008 22:16:11 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
References: <1200906505-28859-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1200906505-28859-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801212216.11784.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 20:08:25 Denis Cheng wrote:
> the original code use KOBJ_NAME_LEN for built-in module name length,
> that's defined to 20 in linux/kobject.h, but this is not enough appearntly,
> many module names are longer than this;
>  #define KOBJ_NAME_LEN                   20

Thanks, applied.  I was surprisedto learn that we have a 35-char source 
filename in the kernel.

And congratulations to nf_conntrack_l3proto_ipv4_compat.c!

Cheers,
Rusty.
