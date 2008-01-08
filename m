Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYAHSCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYAHSCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbYAHSCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:02:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:23281 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYAHSCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:02:40 -0500
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
From: Daniel Walker <dwalker@mvista.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, akpm@linux-foundation.org
In-Reply-To: <20080108175347.GA25968@uranus.ravnborg.org>
References: <20080108161403.GA11632@basil.nowhere.org>
	 <1199811033.1756.29.camel@imap.mvista.com>
	 <20080108175347.GA25968@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 10:01:19 -0800
Message-Id: <1199815279.1756.35.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 18:53 +0100, Sam Ravnborg wrote:
> On Tue, Jan 08, 2008 at 08:50:33AM -0800, Daniel Walker wrote:
> > 
> > On Tue, 2008-01-08 at 17:14 +0100, Andi Kleen wrote:
> > 
> > 
> > > +if ($file) {
> > > +	print <<EOL
> > > +WARNING: Using --file mode. Please do not send patches to linux-kernel
> > > +that change whole existing files if you did not significantly change most
> > > +of the the file for other reasons anyways or just wrote the file newly
> > > +from scratch. Pure code style patches have a significant cost in a
> > > +quickly changing code base like Linux because they cause rejects
> > > +with other changes.
> > > +If you're sure you want to use whole file mode please use --file-force
> > > +EOL
> > > +;
> > > +	exit(1);
> > 
> > Can't say I like this too much .. It sounds like your telling people to
> > stop sending cleanup patches, which doesn't make much sense .. We want a
> > clean kernel .. Or at least I do ..
> 
> It is a simple pain/benefit issue.
> Fixing the 25 errors and 13 warnings in kernel/profile.c may look
> like an easy task but then we put additional burden on the 10 people
> that have patches pending for this file.

This goes for all patches on kernel/profile.c tho .. If I make a big mod
to kernel/profile.c, that will screw up anyone else who has patches for
that file..

> It is the same reason why we do not run a 'kill-trailing-whitespace'
> on the full kernel tree.

At least style clean ups at worst are file by file..

Daniel

