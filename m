Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZCZPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZCZPrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbZCZPrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:47:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28412 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZCZPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:47:05 -0400
Message-ID: <49CBA351.2000007@oracle.com>
Date: Thu, 26 Mar 2009 08:46:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-drivers@serverengines.com
Subject: Re: linux-next: Tree for March 26 (benet)
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
In-Reply-To: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49CBA36D.0115:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090325:


on i386 build:

drivers/built-in.o: In function `be_worker':
be_main.c:(.text+0x827c7): undefined reference to `__udivdi3'
be_main.c:(.text+0x8286c): undefined reference to `__udivdi3'


Probably one of the called functions (that contains
division) is inlined.


-- 
~Randy
