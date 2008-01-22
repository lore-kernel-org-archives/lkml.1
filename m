Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbYAVXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbYAVXNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYAVXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:13:40 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51615 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYAVXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:13:39 -0500
Date: Wed, 23 Jan 2008 00:13:37 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Denis Cheng <crquan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/params.c: fix the module name length in
 param_sysfs_builtin
In-Reply-To: <200801212216.11784.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0801230011300.9183@fbirervta.pbzchgretzou.qr>
References: <1200906505-28859-1-git-send-email-crquan@gmail.com>
 <200801212216.11784.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21 2008 22:16, Rusty Russell wrote:
>On Monday 21 January 2008 20:08:25 Denis Cheng wrote:
>> the original code use KOBJ_NAME_LEN for built-in module name length,
>> that's defined to 20 in linux/kobject.h, but this is not enough appearntly,
>> many module names are longer than this;
>>  #define KOBJ_NAME_LEN                   20
>
>Thanks, applied.  I was surprisedto learn that we have a 35-char source 
>filename in the kernel.
>
>And congratulations to nf_conntrack_l3proto_ipv4_compat.c!

But nf..dada_compat.c gets linked into nf_conntrack_ipv4.ko,
and that is what is used in /sys/module - and it fits the 20.
Any place where nf_conntrack_l3proto_ipv4_compat would still be used?
