Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZJTQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZJTQIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZJTQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:08:17 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:38009 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZJTQIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:08:17 -0400
Date: Tue, 20 Oct 2009 09:06:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-Id: <20091020090627.f36130fb.randy.dunlap@oracle.com>
In-Reply-To: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ADDE065.0165:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 14:17:07 +0900 John W. Linville wrote:

> Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> several years this driver has only seen API "bombing-run" changes, and
> few people ever had the hardware.  This driver represents unnecessary
> ongoing maintenance for no clear benefit.
> 
> This patch brought to you by the "hacking" session at the 2009 Kernel
> Summit in Tokyo, Japan...

is drivers/staging/ a temporary home or a permanent home?

so no explanation of what it means to be in drivers/staging/ and
no warning to users?  either in Kconfig or in feature-removal-schedule.txt?


> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/Kconfig   |   23 -
>  drivers/net/wireless/Makefile  |    1 -
>  drivers/net/wireless/strip.c   | 2805 ----------------------------------------
>  drivers/staging/Kconfig        |    2 +
>  drivers/staging/Makefile       |    1 +
>  drivers/staging/strip/Kconfig  |   22 +
>  drivers/staging/strip/Makefile |    1 +
>  drivers/staging/strip/strip.c  | 2805 ++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 2831 insertions(+), 2829 deletions(-)
>  delete mode 100644 drivers/net/wireless/strip.c
>  create mode 100644 drivers/staging/strip/Kconfig
>  create mode 100644 drivers/staging/strip/Makefile
>  create mode 100644 drivers/staging/strip/strip.c


---
~Randy
