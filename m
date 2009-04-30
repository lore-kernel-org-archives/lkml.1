Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZD3GWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZD3GWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZD3GVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:21:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58212 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZD3GVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:21:52 -0400
Date: Thu, 30 Apr 2009 08:21:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
Message-ID: <20090430062151.GU4593@kernel.dk>
References: <20090429103308.GA23684@squirrel.roonstrasse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429103308.GA23684@squirrel.roonstrasse.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29 2009, Max Kellermann wrote:
> Hi,
> 
> when I read about the splice() system call, I thought it was obvious
> that it could copy data between two pipes.  I was surprised that this
> assumption is wrong, it's not possible on 2.6.29, I get EINVAL.  Can
> anybody please explain this limitation?
> 
> Background: I want to forward data between two subprocesses, which are
> connected to me with a pipe().
> 
> I have attached a small test program which prints a table of supported
> splice operations.  Here's the output on 2.6.29.1:
> 
>  in\out  pipe    sock    reg     chr
>  pipe    no      yes     yes     yes
>  sock    no      no      no      no
>  reg     yes     no      no      no
>  chr     no      no      no      no

See sys_tee().

-- 
Jens Axboe

