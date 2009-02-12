Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZBLFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZBLFf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZBLFfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:35:13 -0500
Received: from tundra.namei.org ([65.99.196.166]:1426 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZBLFfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:35:12 -0500
Date: Thu, 12 Feb 2009 16:34:16 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
In-Reply-To: <20090205081810.331987920@nttdata.co.jp>
Message-ID: <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org>
References: <20090205081810.331987920@nttdata.co.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Kentaro Takeda wrote:

> TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.
> 

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Please fix the following issue detected by sparse:

$ make C=2 SUBDIRS=security/tomoyo CF="-D__cold__="
  CHECK   security/tomoyo/common.c
  CHECK   security/tomoyo/realpath.c
  CHECK   security/tomoyo/tomoyo.c
security/tomoyo/tomoyo.c:110:8: warning: symbol 'buf' shadows an earlier one
security/tomoyo/tomoyo.c:100:7: originally declared here

The fix is not obvious.  You should be running sparse, too.

I also fixed up the link order so security=tomoyo works when root_plug is 
enabled.


- James
-- 
James Morris
<jmorris@namei.org>
