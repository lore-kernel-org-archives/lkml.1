Return-Path: <linux-kernel-owner+w=401wt.eu-S2992696AbXEBDyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992696AbXEBDyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992698AbXEBDyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:54:09 -0400
Received: from [69.90.0.18] ([69.90.0.18]:57563 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S2992696AbXEBDyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:54:07 -0400
Date: Tue, 1 May 2007 23:54:04 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: "Cabot, Mason B" <mason.b.cabot@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705012353100.5330@mtl.rackplans.net>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Cabot, Mason B wrote:

> Hello all,
> 
> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.
> 
> I've posted a brief paper on Intel's OSS website
> (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> it a read and let me know what you think. In particular, I'd like to
> arrive at the right place to fix this problem: is it in the filesystem,
> VFS, or Samba?
> 
> thanks,
> Mason 
> 

Just out of curiosity do other filesystems(reiser, xfs) take the same 
performance hit?

	Gerjard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
