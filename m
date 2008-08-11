Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYHKRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYHKRM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYHKRLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:11:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40527 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYHKRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:11:53 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808111853.13854.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	 <200808111853.13854.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 10:11:45 -0700
Message-Id: <1218474705.5598.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 18:53 +0200, Arnd Bergmann wrote:
> The best way I can think of for this would be to use existing syscalls
> (e.g. sched_setscheduler, setfsuid, ...) from user space whereever
> possible and do only the bare minimum for the restart part in the
> kernel.

Well, the current direction is about as far away from that as you can
get, unless we basically call those system calls from inside our new
sys_restart() one.  As of now, we're as much work in the kernel as
possible, and doing the bare minimum in userspace.  That's what both
Oren and our OpenVZ colleagues have advocated.

-- Dave

