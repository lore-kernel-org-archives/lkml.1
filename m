Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYAJABZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYAJABZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbYAJABJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:01:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYAJABH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:01:07 -0500
Date: Thu, 10 Jan 2008 00:00:43 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080110000043.GI3510@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Vadim Lobanov <vlobanov@speakeasy.net>,
	Chris Friesen <cfriesen@nortel.com>,
	Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <478551A6.9050803@nortel.com> <20080109230545.GG3510@agk.fab.redhat.com> <200801091531.00483.vlobanov@speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801091531.00483.vlobanov@speakeasy.net>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:31:00PM -0800, Vadim Lobanov wrote:
> From 2.6.23's fs/ioctl.c - do_ioctl():
 
Ah - you're talking about struct file_operations of course;
I was talking about struct block_device_operations.

Alasdair
-- 
agk@redhat.com
