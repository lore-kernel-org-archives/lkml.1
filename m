Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZARXai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZARXai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZARXa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:30:26 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47890 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZARXaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:30:25 -0500
Message-ID: <4973BB3F.8090702@oracle.com>
Date: Sun, 18 Jan 2009 15:29:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: FS-Cache fixes for IA64 export and AFS linkage
References: <16871.1232172044@redhat.com>
In-Reply-To: <16871.1232172044@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4973BB44.00CA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> I've dropped the patch to export copy_page() for IA64 from my patchset and
> updated the AFS patch so that it no longer produces link errors if
> CONFIG_AFS_FS=y and CONFIG_FSCACHE=m but CONFIG_AFS_FSCACHE=n.
> 
> These patches are now available as:
> 
> 	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-44.tar.bz2
> 
> and I've updated my GIT tree for Trond to pull:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-2.6-nfs-fscache.git;a=shortlog

Ack.  Builds for me.  Thanks.

-- 
~Randy
