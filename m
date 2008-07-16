Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYGPKLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYGPKLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbYGPKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:11:32 -0400
Received: from gw.goop.org ([64.81.55.164]:55515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbYGPKLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:11:31 -0400
Message-ID: <487DC943.5060202@goop.org>
Date: Wed, 16 Jul 2008 03:11:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>, Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com>
In-Reply-To: <487D78A3.6050105@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> +#ifdef CONFIG_STOP_MACHINE
> +extern unsigned long stopmachine_timeout;
> +#endif
>   

No externs in C files. Put it in an appropriate header.

I'll do a proper review soon.

J
