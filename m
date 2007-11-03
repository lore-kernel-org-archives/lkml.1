Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXKCKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXKCKdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 06:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXKCKdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 06:33:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46367 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXKCKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 06:33:10 -0400
Subject: Re: [PATCH 7/10] 9p: sysfs support for in-kenel servers
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20071103034812.GC16234@kroah.com>
References: <20071102170527.GH16063@ionkov.net>
	 <20071103034812.GC16234@kroah.com>
Content-Type: text/plain
Date: Sat, 03 Nov 2007 11:33:05 +0100
Message-Id: <1194085985.27652.409.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 20:48 -0700, Greg KH wrote:

> Also, a sysfs file that causes an action to happen just by reading the
> file is not a safe thing to have.  Lots of scripts have been known to
> just walk the whole sysfs tree and open and read everything they can for
> no real good reason.  So you should seriously reconsider this kind of
> interaction.

Christoph, doesn't SLUB do exactly that?

