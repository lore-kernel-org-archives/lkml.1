Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYADKsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYADKsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYADKsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:48:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45792 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYADKr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:47:59 -0500
Date: Fri, 4 Jan 2008 10:47:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       dhowells@redhat.com
Subject: Re: isofs oops - d_splice_alias+0x1f (2.6.24-rc5-mm1)
Message-ID: <20080104104755.GX27894@ZenIV.linux.org.uk>
References: <477CE1E0.4010504@gmail.com> <Pine.LNX.4.64.0801031550160.2076@sbz-30.cs.Helsinki.FI> <477CEE1C.7020005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477CEE1C.7020005@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 03:15:56PM +0100, Jiri Slaby wrote:

> Can't say, the DVD seems to be OK, I don't know what was wrong (as I can say,
> this happened several times in the past yet and after reboot everything OK; I
> suspect gnome auto mounter -- multiple machines, several DVD ROMs, same disk
> with OS, similar errors, but that's too few to report).

It is -mm-specific, all right - fallout from
	iget-stop-isofs-from-using-read_inode.patch
not covered in
	iget-stop-isofs-from-using-read_inode-fix*

Callers in fs/isofs/namei.c are missed.
