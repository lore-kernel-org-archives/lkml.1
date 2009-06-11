Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbZFKWdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbZFKWdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZFKWdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:33:00 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40936 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbZFKWc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:32:59 -0400
Message-ID: <4A318519.2080708@oracle.com>
Date: Thu, 11 Jun 2009 15:28:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       marcel@holtmann.org, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: linux-next: Tree for June 11 (bluetooth/rfkill)
References: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au>
In-Reply-To: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.4A3185F1.014B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090610:


CONFIG_RFKILL=m
CONFIG_BT=y

(.text+0xb7bf7): undefined reference to `rfkill_unregister'
(.text+0xb7c03): undefined reference to `rfkill_destroy'
(.text+0xb962f): undefined reference to `rfkill_blocked'
(.text+0xba173): undefined reference to `rfkill_alloc'
(.text+0xba187): undefined reference to `rfkill_register'
(.text+0xba197): undefined reference to `rfkill_destroy'


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
