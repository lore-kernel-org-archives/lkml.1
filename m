Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYGXSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYGXSbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYGXSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:31:05 -0400
Received: from gw.goop.org ([64.81.55.164]:44828 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYGXSbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:31:04 -0400
Message-ID: <4888CA62.5010602@goop.org>
Date: Thu, 24 Jul 2008 11:30:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: patrizio.bassi@gmail.com
CC: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26 vanilla paravirt config issue
References: <4888B8CD.1030501@gmail.com>
In-Reply-To: <4888B8CD.1030501@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrizio Bassi wrote:
> Hi All
>
> on my amd64 profile i cannot disable PARAVIRT option.
>
> even if i disable all i still get in my .config:
>
> # CONFIG_X86_ES7000 is not set
> # CONFIG_X86_RDC321X is not set
> CONFIG_X86_VSMP=y
> # CONFIG_PARAVIRT_GUEST is not set
> CONFIG_PARAVIRT=y    <<<<-------------------------------- issue
> # CONFIG_MEMTEST_BOOTPARAM is not set
> # CONFIG_M386 is not set
>
> how to disable it? i guess it's a config bug.

As Randy pointed out, VSMP selects PARAVIRT.  VSMP does something 
strange with AC in rflags and interrupt enable/disable, and so hooks the 
appropriate pvops to implement it.

What's your underlying concern about PARAVIRT?

    J
