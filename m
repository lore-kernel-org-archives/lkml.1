Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZALQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZALQ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZALQ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:28:24 -0500
Received: from cet.com.ru ([195.178.208.66]:46800 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZALQ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:28:23 -0500
Date: Mon, 12 Jan 2009 19:28:20 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Dave Jones <davej@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112162820.GA22881@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112162209.GB7046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112162209.GB7046@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:22:09AM -0500, Dave Jones (davej@redhat.com) wrote:
>  > Not one, but tasks which have the given string in the name. Like script
>  > names spawned at DoS time.
> 
> There is also the problem that process names aren't unique.
> If the process table contains two entries called 'Kenny', there's nothing
> that says they came from the same executable.

Agree, oom-killer will try to get theirs points and if they are really
different applications, the 'bad' one will be killed.

-- 
	Evgeniy Polyakov
