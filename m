Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZCRRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZCRRBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZCRRBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:01:09 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43877 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZCRRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:01:07 -0400
Subject: Re: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in
 struct btrfs_fid
From: Chris Mason <chris.mason@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: balajirrao@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
References: <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 13:00:29 -0400
Message-Id: <1237395629.10384.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.49C128B3.014A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 16:16 +0000, David Howells wrote:
> Transpose parent_objectid and parent_gen in struct btrfs_fid so that gen and
> parent_gen (both u32) are adjacent, thus packing nicely between the u64
> members.
> 
> This would seem to be reasonable as the parent generation number is always
> used if the parent objectid is.
> 

Won't this confuse any handles the clients already have if the server
reboots with the new handle format?

-chris


