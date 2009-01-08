Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZAHNcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZAHNcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZAHNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:32:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45802 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZAHNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:32:31 -0500
Date: Thu, 8 Jan 2009 13:32:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Moulder <pjrm@mail.internode.on.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20090108133220.GA11254@srcf.ucam.org>
References: <20081228152901.GB13565@srcf.ucam.org> <20090108122952.GA19743@mail.internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090108122952.GA19743@mail.internode.on.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 11:29:53PM +1100, Peter Moulder wrote:
> What was the fate of Ingo's previous patch[*1] to implement this (which,
> incidentally, also included updates to documentation and made the interval
> configurable as Éric Piel suggests) ?

Nobody merged it and Ingo got bored of pushing it. I sent it earlier, 
but nobody came up with an especially good argument for the 
configurability and everyone seemed to want to paint the patch pink with 
yellow polka dots, so I gave up and just sent a minimal one in the hope 
that nobody could find anything to complain about.

> Just a minor nit, but the patch description (not included in the patch itself)
> "at least once a day" isn't particularly accurate given that the patch enforces
> at least a day [minus a second or so] has elapsed since the last update.  The
> description in the above-referenced patch "only once a day" better captures the
> situation, I think.

If mtime is changed then atime will be updated on the next access, so 
you can easily have more than one atime update a day.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
