Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYGXRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYGXRl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYGXRls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:41:48 -0400
Received: from xenotime.net ([66.160.160.81]:50735 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751529AbYGXRlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:41:47 -0400
Date: Thu, 24 Jul 2008 10:41:46 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Patrizio Bassi <patrizio.bassi@gmail.com>
cc: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26 vanilla paravirt config issue
In-Reply-To: <4888B8CD.1030501@gmail.com>
Message-ID: <Pine.LNX.4.64.0807241041000.3283@shark.he.net>
References: <4888B8CD.1030501@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008, Patrizio Bassi wrote:

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

Nope.  You have CONFIG_X86_VSMP enabled, which selects PARAVIRT:

config X86_VSMP
	bool "Support for ScaleMP vSMP"
	select PARAVIRT
	depends on X86_64

> CC me i'm not subscribed.

-- 
~Randy
