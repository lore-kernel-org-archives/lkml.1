Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZH0QxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZH0QxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZH0QxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:53:18 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:18857 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZH0QxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:53:18 -0400
Date: Thu, 27 Aug 2009 09:55:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Celejar <celejar@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, 541835@bugs.debian.org
Subject: Re: crypto configuration / dependencies broken
Message-Id: <20090827095516.6817be1e.randy.dunlap@oracle.com>
In-Reply-To: <20090825195852.1dfacb6c.celejar@gmail.com>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A96B9F5.01C1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 19:58:52 -0400 Celejar wrote:

> I'm having a pretty bizarre problem with my kernel crypto
> configuration.  I need support for a bog standard LUKS (aes /
> cbc-essiv:sha256) / cryptsetup installation, but even after I enable
> virtually everything in the crypto section of the kernel configs, cbc
> fails to load.  All the relevant modules are exist (dm-mod, dm-crypt,
> crypto_blkcipher, crypto_algapi, crypto_hash, aes_generic,
> sha256_generic), but even after modprobing / insmoding
> everything, /proc/crypto shows that aes and sha is there, but not cbc.
> 
> The problem has been reproduced (using my kernel config) by Jonas
> Meurer, the Debian cryptsetup maintainer, so it's not just me ;).
> We've tried numerous different kernel versions in the .30 / .31 range.
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=541835
> 
> Does this mean that something else somewhere in the kernel needs to be
> configured but isn't, and the necessary dependency isn't properly
> declared?
> 
> My config is at:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=45;filename=config-2.6.31-rc6-lizzie-00042-gb2add73;att=1;bug=541835
> 
> [I'm not subscribed to lkml; please cc me on responses]


You could try/test a patch that was just posted:
  http://lkml.org/lkml/2009/8/27/249


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
