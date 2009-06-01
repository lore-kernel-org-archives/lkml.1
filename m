Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZFATCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZFATCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZFATCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:02:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55833 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbZFATCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:02:14 -0400
Date: Mon, 1 Jun 2009 21:09:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601190914.GV1065@one.firstfloor.org>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <1243877766.8547.38.camel@psmith-ubeta.netezza.com> <20090601184934.1fc54411@lxorguk.ukuu.org.uk> <1243881544.8547.66.camel@psmith-ubeta.netezza.com> <20090601200232.078aacbb@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601200232.078aacbb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 08:02:32PM +0100, Alan Cox wrote:
> > If a program seems to be unresponsive the user could ^C, without
> > realizing that it was really dumping core.  Now when they are asked to
> > produce the core so the problem can be debugged, they can't do it.  Or,
> 
> and get their prompt back, which is probably why they are banging ^C. If
> they didn't want their prompt back at that point they'd still be
> wondering why nothing was occuring at the point it said (core dumped)

Maybe we need a background core dump?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
