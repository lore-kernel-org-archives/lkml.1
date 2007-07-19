Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXGSDmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXGSDmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXGSDmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:42:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39783 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXGSDmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:42:22 -0400
Date: Wed, 18 Jul 2007 20:41:55 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
       cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com,
       michael.kerrisk@gmx.net
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Message-ID: <20070719034155.GE32734@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713184625.GB12156@amitarora.in.ibm.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> After a successful call, subsequent writes are guaranteed not to fail because
> of lack of disk space.
  
If a write to an unwritten region requires a node split, that could result
in the allocation of new meta data which obviously could fail if the disk is
truly full.

Granted that's unlikely to happen but maybe we should be conservative and
say something like:

"After a successful call, subsequent writes are guaranteed to never require
allocation of file data." ?
        --Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
