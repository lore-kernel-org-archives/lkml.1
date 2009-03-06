Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZCFTAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZCFTAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZCFTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:00:23 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:32862 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZCFTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:00:22 -0500
Message-ID: <49B17320.8010000@oracle.com>
Date: Fri, 06 Mar 2009 11:01:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
In-Reply-To: <20090306191311.697e7b97.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49B172BD.0072:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Linus' release of -rc7 seems to have stirred people up a bit ...
> 
> Changes since 20090305:


when CONFIG_RFKILL=n, ath9k/virtual.c causes:

(.text+0x224e83): undefined reference to `ath_radio_disable'
(.text+0x224e8b): undefined reference to `ath_radio_enable'



-- 
~Randy
