Return-Path: <linux-kernel-owner+w=401wt.eu-S1030183AbXAXEq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183AbXAXEq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965660AbXAXEq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:46:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654AbXAXEq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:46:57 -0500
Date: Tue, 23 Jan 2007 20:46:48 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] i_ino uniqueness: alternate approach -- hash the
 inodes
Message-Id: <20070123204648.204b1834.akpm@osdl.org>
In-Reply-To: <200701161857.l0GIvcaA016196@dantu.rdu.redhat.com>
References: <200701161857.l0GIvcaA016196@dantu.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 13:57:38 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> The questions are:
> 
> 1) how much would this slow down lookups for these filesystems?
> 2) is it enough to justify adding more infrastructure to avoid it?
> 
> What might be best is to start with this approach and then only move to using
> IDR or some other scheme if these extra inodes in the hashtable prove to be
> problematic.
> 
> I've done some cursory testing with this patch and the overhead of hashing
> and unhashing the inodes with pipefs is pretty low -- just a few seconds of
> system time added on to the creation and destruction of 10 million pipes (very
> similar to the overhead that the IDR approach would add).

What is the additional overhead, expressed in relative terms?  ie: as a percentage?
