Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYAFAvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYAFAvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYAFAvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:51:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:6310 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbYAFAvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iHejZNn0Mn0T19iX/qBQbag9xJhVaG/c1S5IieAGWUceSA8yrHQBDLh+jC6d/flCzEJFX44IeylhpudOourX+rOhtj7jfDbC2OoZLnNzRRmByg5Y5MIs9mNdzwVhbVxaa32ZmE7xrWMaDRyq+xlwhmZ0rCtLugfzECJtA8nGRcs=
Date: Sun, 6 Jan 2008 01:52:29 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] udf: improve code related to super_block v3
Message-ID: <20080106005224.GA4522@joi>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ehh, forgot to add patching order :(

Should be:
[PATCH 1/6] udf: fix coding style of super.c
[PATCH 2/6] udf: remove some ugly macros
[PATCH 3/6] udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
[PATCH 4/6] udf: check if udf_load_logicalvol failed
[PATCH 5/6] udf: convert some macros to functions
[PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
