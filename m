Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYCJVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYCJVzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYCJVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:55:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58724 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYCJVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:55:34 -0400
Date: Mon, 10 Mar 2008 14:55:25 -0700
From: Greg KH <greg@kroah.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       systemtap@sourceware.org, prasadav@us.ibm.com, hch@infradead.org
Subject: Re: [patch 3/3]  Trace sample
Message-ID: <20080310215525.GA28186@kroah.com>
References: <1204065533.26964.18.camel@lc4eb748232119.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204065533.26964.18.camel@lc4eb748232119.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 02:38:52PM -0800, David J. Wilder wrote:
> + * This module creates a trace channel and places a kprobe
> + * on the function do_fork(). The value of current->pid is written to
> + * the trace channel each time the kprobe is hit..
> + *
> + * How to run the example:
> + * $ mount -t debugfs /debug

Tiny note, debugfs is supposed to be mounted in /sys/kernel/debug/, not
/debug.

thanks,

greg k-h
