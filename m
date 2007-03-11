Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXCKCaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXCKCaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbXCKCaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:30:15 -0500
Received: from ozlabs.org ([203.10.76.45]:36509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbXCKCaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:30:14 -0500
Subject: Re: [RFC PATCH 1/3] Add ability to keep track of callers of
	symbol_(get|put)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1173501095.26213.405.camel@localhost>
References: <1173501095.26213.405.camel@localhost>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 13:29:14 +1100
Message-Id: <1173580154.32234.161.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 02:31 -0200, Mauro Carvalho Chehab wrote:
> From: Trent Piepho <xyzzy@speakeasy.org>
> 
> When a module uses symbol_get() to increase the ref count of another
> module, there is no record what module called symbol_get().  A module
> can
> show up as having other users, but there is no way to tell who those
> users are.

Hi Mauro,

	Interesting: in general you cannot tell who is using a module, but for
this case it makes sense.  Your patch was linewrapped here, but it all
looks fine.

Thanks,
Rusty.

