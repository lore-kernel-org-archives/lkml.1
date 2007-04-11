Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXDKTiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXDKTiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030190AbXDKTiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:38:50 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46022 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030181AbXDKTit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:38:49 -0400
Date: Wed, 11 Apr 2007 15:38:44 -0400
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] AFS: Add security support
Message-ID: <20070411193844.GC3704@fieldses.org>
References: <20070411190956.15499.55352.stgit@warthog.cambridge.redhat.com> <20070411191037.15499.67852.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411191037.15499.67852.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 08:10:37PM +0100, David Howells wrote:
> Add security support to the AFS filesystem.  Kerberos IV tickets are
> added as RxRPC keys are added to the session keyring with the klog
> program.  open() and other VFS operations then find this ticket with
> request_key() and either use it immediately (eg: mkdir, unlink) or
> attach it to a file descriptor (open).

Just curious--when is the actual crypto done?  There doesn't seem to be
any in this patch.

--b.
