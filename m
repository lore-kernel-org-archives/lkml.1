Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZHKRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZHKRHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbZHKRHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:07:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:51812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbZHKRHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:07:44 -0400
Date: Tue, 11 Aug 2009 10:00:50 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1] Power: fix suspend vt regression
Message-ID: <20090811170050.GA26041@suse.de>
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249980093-16319-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:41:33AM +0200, Jiri Slaby wrote:
> vt_waitactive no longer accepts console parameter as console-1
> since commit "vt: add an event interface". It expects console
> number directly (as viewed by userspace -- counting from 1).

As the event interface code is only in -next and not in mainline, this
doesn't pertain to Linus's current tree, right?

thanks,

greg k-h
