Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZAQGDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZAQGDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbZAQGD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:03:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbZAQGD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:03:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
cc: dhowells@redhat.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>
Subject: FS-Cache fixes for IA64 export and AFS linkage
Date: Sat, 17 Jan 2009 06:00:44 +0000
Message-ID: <16871.1232172044@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've dropped the patch to export copy_page() for IA64 from my patchset and
updated the AFS patch so that it no longer produces link errors if
CONFIG_AFS_FS=y and CONFIG_FSCACHE=m but CONFIG_AFS_FSCACHE=n.

These patches are now available as:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-44.tar.bz2

and I've updated my GIT tree for Trond to pull:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-2.6-nfs-fscache.git;a=shortlog

David
