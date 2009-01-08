Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZAHALY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZAHALY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZAHALK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:11:10 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:41356 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZAHALJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:11:09 -0500
Message-ID: <4965448D.7000607@oracle.com>
Date: Wed, 07 Jan 2009 16:10:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
CC: netdev@vger.kernel.org, wimax@linuxwimax.org, greg@kroah.com,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: Re: [PATCH 0/4] wimax: Kbuild / rfkill-build / PM fixes (v3)
References: <cover.1231355768.git.inaky@linux.intel.com>
In-Reply-To: <cover.1231355768.git.inaky@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49654491.0141:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inaky Perez-Gonzalez wrote:
> These four patches fix build issues reported by Randy Dunlap on the
> linux-next tree for Jan 6 and Jan 7:
> 
> http://lkml.org/lkml/2009/1/6/340
> http://lkml.org/lkml/2009/1/7/360
> 
> The issue fixed by patch #3 wasn't reported on the emails but was
> uncovered while discussing the fixes.
> 
> This applies to the wimax tree kept in gregkh's repository:
> 
> http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/

Ack.  They all work for me.  Thanks.


> Changes in v3
> 
> - Add patch #4, wrapping access to power-saving members of the struct
>   usb_device in #ifdef CONFIG_PM. 
> 
> Changes in v2
> 
> - fixed silly one-char typo #ifndef CONFIG_BUG vs #ifdef CONFIG_BUG
>   reported by Ilpo Järvinen 
> 
> Inaky Perez-Gonzalez (4):
>   wimax: fix '#ifndef CONFIG_BUG' layout to avoid warning
>   wimax: fix kconfig interactions with rfkill and input layers
>   wimax: testing for rfkill support should also test for
>     CONFIG_RFKILL_MODULE
>   i2400m/usb: wrap USB power saving in #ifdef CONFIG_PM
> 
>  drivers/net/wimax/i2400m/usb.c |    6 ++++++
>  net/wimax/Kconfig              |   14 ++++++++++++++
>  net/wimax/id-table.c           |    8 +++++---
>  net/wimax/op-rfkill.c          |    2 +-
>  4 files changed, 26 insertions(+), 4 deletions(-)
> 


-- 
~Randy
