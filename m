Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXEAQRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXEAQRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXEAQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:17:12 -0400
Received: from thunk.org ([69.25.196.29]:49918 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbXEAQRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:17:10 -0400
Date: Tue, 1 May 2007 12:17:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Xu CanHao <xucanhao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
Message-ID: <20070501161707.GD26093@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Xu CanHao <xucanhao@gmail.com>, linux-kernel@vger.kernel.org
References: <6ec7a4340705010617h4314045cj7f0aee42eb22292b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ec7a4340705010617h4314045cj7f0aee42eb22292b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:17:14PM +0800, Xu CanHao wrote:
> Reiser4 may lack some core function, but ZFS on Solaris is as
> functional as ext3 on Linux(or even more). So compare Reiser4 with
> ZFS may be inappropriate.

Functional, but it's a new filesystem with not as much time-tested
experience in the field.  Many Solaris system administrators are
electing to wait rather than immediately press it into service for
critical servers, electing to use Solaris's UFS instead.  I've heard a
few problems with ZFS recovering from data corruption, but not enough
to know whether it is a general trend (not that I track that kind of
stuff).  As a rule, enterprise system administrators that run PO
servers for thousands of users as a time are extremely conservative,
and for good reason.   

Of course, there's a big difference between those folks and people
using ZFS for their own personal development.

						- Ted
