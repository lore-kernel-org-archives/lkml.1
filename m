Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYHNPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYHNPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYHNPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:12:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51173 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbYHNPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:12:20 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20080814055301.GH6995@ucw.cz>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz>
	 <200808090013.41999.arnd@arndb.de> <1218234411.19082.58.camel@nimitz>
	 <20080811150703.GA25930@us.ibm.com>  <20080814055301.GH6995@ucw.cz>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 08:12:16 -0700
Message-Id: <1218726736.23641.2.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 07:53 +0200, Pavel Machek wrote:
> > As Oren has pointed out before, passing in an fd means we can pass a
> > socket into the syscall.
> 
> If you do pass a socket, will it handle blocking correctly? Getting
> deadlocked task would be bad. What happens if I try to snapshot into
> /proc/self/fd/0 ? Or maybe restore from /proc/cmdline?

Heh, that's a good point.  What was the other code where we kept coming
up with deadlocks like that?  Anyone remember?

-- Dave

