Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZALQWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZALQWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZALQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:22:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZALQWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:22:30 -0500
Date: Mon, 12 Jan 2009 11:22:09 -0500
From: Dave Jones <davej@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112162209.GB7046@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112155615.GA21350@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:56:15PM +0300, Evgeniy Polyakov wrote:
 > On Mon, Jan 12, 2009 at 03:52:39PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
 > > > Which has to be checked for every process ever created,
 > > > which is quite unfeasible in some conditions.
 > > 
 > > The task name is not a reliable indicator of true name and truncated so
 > > is useless. You only nominate one task, you don't integrate with the
 > > existing interface.
 > 
 > Not one, but tasks which have the given string in the name. Like script
 > names spawned at DoS time.

There is also the problem that process names aren't unique.
If the process table contains two entries called 'Kenny', there's nothing
that says they came from the same executable.

	Dave

-- 
http://www.codemonkey.org.uk
