Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYJ0WEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYJ0WEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJ0WEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:04:36 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:43499 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYJ0WEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:04:35 -0400
Date: Mon, 27 Oct 2008 23:04:19 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Hartmut Niemann <Hartmut.Niemann@gmx.de>
Cc: Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
Subject: Re: [PATCH] Documentation/filesystems/nfsroot.txt: CONFIG_IP_PNP
	must be set
Message-ID: <20081027220419.GA12618@citd.de>
References: <200810252347.01484.Hartmut.Niemann@gmx.de> <20081027052409.GC6818@verge.net.au> <200810272241.14531.Hartmut.Niemann@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810272241.14531.Hartmut.Niemann@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.10.2008 22:41, Hartmut Niemann wrote:
> The file nfsroot.txt fails to mention, that Kernel level autoconfiguration 
> CONFIG_IP_PNP must be selected in order to be able to even see
> the option "Root file system on NFS" (CONFIG_ROOT_NFS)
> 
> I reordered the section 1 of nfsroot.txt and emphasized the dependency.
> (And I fixed some chapter numbering in section 3).

Technically you neither need autoconfiguration nor CONFIG_ROOT_NFS.

With an initrd/initramfs you can do the whole procedure from userspace.

And AFAIR a few years back those options where on the brink of beeing 
deprecated for just that reason.


Just my 2 cents.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

