Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYD3BrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYD3BrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYD3BrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:47:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43462 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYD3BrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:47:04 -0400
Subject: Re: [RFC][PATCH 2/5] introduce simple_set_mnt_no_get() helper for
	NFS
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
In-Reply-To: <1209504893.8321.2.camel@heimdal.trondhjem.org>
References: <20080429185943.3BA6A050@kernel>
	 <20080429185945.8D7AD196@kernel>
	 <1209504893.8321.2.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 18:46:55 -0700
Message-Id: <1209520015.27659.20.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 14:34 -0700, Trond Myklebust wrote:
> My only concern is the proliferation of 'simple_*' operations: in some
> cases in libfs.c we explicitly label those as being for in-memory/ramfs
> filesystems, whereas in other cases (such as this one) the name appears
> to be used for more generic functions.

I'm all to happy to give it a different name.  Any suggestions?

-- Dave

