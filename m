Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYBESAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYBESAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYBESA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:00:27 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48732 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYBESA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:00:26 -0500
Subject: Re: [PATCH 2.6.24-rc8-mm1 09/15] (RFC) IPC: new kernel API to
	change an ID
From: Dave Hansen <haveblue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <47A83194.8060808@cs.columbia.edu>
References: <20080129160229.612172683@bull.net>
	 <20080129162000.454857358@bull.net>
	 <20080129210656.GB1990@martell.zuzino.mipt.ru>	<47A18E47.5050206@bull.net>
	 <47A19AC2.7040709@sw.ru> <47A1B78C.7050405@bull.net>
	 <47A83194.8060808@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 10:00:25 -0800
Message-Id: <1202234426.10699.209.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 04:51 -0500, Oren Laadan wrote:
> That said, I suggest the following method instead (this is the method
> we use in Zap to determine the desired resource identifier when a new
> resource is allocated; I recall that we had discussed it in the past,
> perhaps the mini-summit in september ?):
> 
> 1) The process/thread tells the kernel that it wishes to pre-determine
> the resource identifier of a subsequent call (this can be done via a
> new syscall, or by writing to /proc/self/...).
> 
> 2) Each system call that allocates a resource and assigns an
> identifier
> is modified to check this per-thread field first; if it is set then
> it will attempt to allocate that particular value (if already taken,
> return an error, eg. EBUSY). Otherwise it will proceed as it is today.

You forgot to attach the patch to your mail. ;)

-- Dave

