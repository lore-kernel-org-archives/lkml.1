Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0CCRzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:55:54 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:65026 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab0CCRzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:55:50 -0500
Message-ID: <4B8EAB94.4090304@Calva.COM>
Date: Wed, 03 Mar 2010 19:33:56 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
 on different filesystems seems to deadlock in sync
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk>
In-Reply-To: <20100303120317.GP5768@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Our sync is currently broken in that regard, since it'll wait for too
> long. We have a debated patch going, I have included it below. Any
> chance you could give it a whirl?
>
> The semantics of sync are supposed to be 'wait for dirty IO generated
> BEFORE this sync call'.
>
>   
This patch doesn't seem to change things.  It's a bit late here, I'll 
check my results tomorrow.

