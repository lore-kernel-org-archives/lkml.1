Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZA1D5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZA1D5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZA1D5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:57:43 -0500
Received: from vena.lwn.net ([206.168.112.25]:34724 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZA1D5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:57:42 -0500
Date: Tue, 27 Jan 2009 20:57:39 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090127205739.1384343f@bike.lwn.net>
In-Reply-To: <20090128031439.GA11025@redhat.com>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122203248.GA20159@infradead.org>
	<20090123045646.GK15750@one.firstfloor.org>
	<20090127165504.53ed7a2d.akpm@linux-foundation.org>
	<20090128031439.GA11025@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 04:14:39 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> I'll try to make the patch tomorrow, but the problem is that I am not
> sure this is not too ugly.

FWIW, I'm partway through a new attempt using bitops for f_flags, moving
FASYNC flag handling into fasync_helper(), and doing away with
additional locks altogether.  I have to get past the publication
deadline before I can finish it, though.

jon
