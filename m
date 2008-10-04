Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYJDWiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYJDWiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYJDWii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:38:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48797 "EHLO
	vinyl.outflux.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754210AbYJDWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:38:37 -0400
X-Greylist: delayed 2167 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Oct 2008 18:38:37 EDT
Date: Sat, 4 Oct 2008 15:02:20 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081004220220.GK10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004145149.52c34ee7@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 02:51:49PM -0700, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 14:14:24 -0700
> Kees Cook <kees.cook@canonical.com> wrote:
> 
> > There is no sane way to query the personality flags of arbitrary
> > process from userspace.  This adds the flags to the /proc/$pid/status
> > file. For example, to detect READ_IMPLIES_EXEC:
> > 
> 
> .. I'm sure local exploit writers will love this to find out which
> processes to attack.
> Realistically, this probably shouldn't be in a world-readable file.

Nothing else seemed appropriate, but I could make a brand new proc file,
if that's sensible.  "status_private" ?

-Kees

-- 
Kees Cook
Ubuntu Security Team
