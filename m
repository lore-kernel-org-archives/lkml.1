Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZJZPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZJZPsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZJZPsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:48:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:38083 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZJZPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:48:42 -0400
Date: Mon, 26 Oct 2009 08:43:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       cluster-devel@redhat.com
Subject: Re: linux-next: Tree for October 26 (gfs2)
Message-Id: <20091026084356.847d1ae2.randy.dunlap@oracle.com>
In-Reply-To: <20091026172104.205f15af.sfr@canb.auug.org.au>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AE5C4CB.008A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 17:21:04 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091016:


on i386:

(.text+0x723a8b): undefined reference to `__divdi3'

super.c::gfs2_statfs_change():
		percent = (100 * l_sc->sc_free) / m_sc->sc_free;


I guess it needs to use div64() etc.

---
~Randy
