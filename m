Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYFIUtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYFIUtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYFIUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:49:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYFIUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:49:38 -0400
Date: Mon, 9 Jun 2008 13:49:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: lkml@metanurb.dk, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Make some ext3 kernel messages useful by showing device
Message-Id: <20080609134918.ed83d0d7.akpm@linux-foundation.org>
In-Reply-To: <484D3378.9090708@redhat.com>
References: <1212951761.32756.4.camel@localhost>
	<20080609025926.0ecb6aea.akpm@linux-foundation.org>
	<484D3378.9090708@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 08:43:20 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> > 
> > It is very much preferred, thanks.
> > 
> > (patch retained for linux-ext4 review)
> 
> The patch itself looks fine to me, and is a good idea.  I recently saw a
> confused user on another fs where successful mount messages were
> followed by failure mount messages with no indication of which fs had
> the trouble...
> 
> There probably are more spots in extX which could use this treatment...
> should we maybe just be using ext3_warning in more places, which
> automatically prints the sb, function name, etc?

Good point, thanks.
