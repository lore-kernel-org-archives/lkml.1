Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYJBW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYJBW4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYJBW4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:56:32 -0400
Received: from mylar.outflux.net ([69.93.193.226]:51325 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYJBW4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:56:32 -0400
Date: Thu, 2 Oct 2008 15:56:24 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081002225624.GK10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <Pine.LNX.4.64.0810021544070.26309@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810021544070.26309@shark.he.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya Randy,

On Thu, Oct 02, 2008 at 03:46:31PM -0700, Randy.Dunlap wrote:
> On Thu, 2 Oct 2008, Kees Cook wrote:
> > There is no sane way to query the personality flags of arbitrary process
> > from userspace.  This adds the flags to the /proc/$pid/status file.
> 
> The patch seems to be missing an update to Documentation/filesystems/proc.txt !
> Please add that.  TIA.

The /proc/pid/status file is "self documenting" (in theory), and doesn't
have separate documentation in proc.txt yet.  If I had touched the
"stat" file, I would have included and update, since I was the last to
document that file.  ;)

-Kees

-- 
Kees Cook
Ubuntu Security Team
