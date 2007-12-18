Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbXLRXA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbXLRXA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXLRXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:00:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33889 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbXLRXAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:00:20 -0500
Date: Tue, 18 Dec 2007 23:00:16 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
Message-ID: <20071218230016.GF8181@ftp.linux.org.uk>
References: <47684DBD.6030502@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47684DBD.6030502@rtr.ca>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:46:21PM -0500, Mark Lord wrote:
> Why does link(2) not support hard-linking across bind mount points
> of the same underlying filesystem ?

Because it gives you a security boundary around a subtree.
