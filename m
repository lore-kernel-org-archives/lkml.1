Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZJTFye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZJTFye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZJTFyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:54:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31465 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZJTFyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:54:32 -0400
Subject: Re: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jiri Kosina <jkosina@suse.cz>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.0910191658260.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191616290.8582@wotan.suse.de>
	 <94a0d4530910190757y139c7e20xe6a58f0cbf13a79d@mail.gmail.com>
	 <alpine.LSU.2.00.0910191658260.8582@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Oct 2009 08:53:19 +0300
Message-Id: <1256017999.29856.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Oct 2009 05:53:21.0482 (UTC) FILETIME=[A157AAA0:01CA5149]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 17:03 +0200, Jiri Kosina wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
> 
> > > I have never been in favor of merging whitespace-only patches (in a 
> > > sense that the sole purpose of them being to change whitespaces, but 
> > > no else value added).
> > If somebody tries to send a patch for that file that doesn't fix the
> > white-space, checkpatch will complain, and people will complain that
> > checkpatch complains, which is precisely what happened, 
> 
> Oh, well ... checkpatch warning about this is somewhat controversial. My 
> preferred way would be that it warns about whitespace only if there are 
> also some other (non-whitespace) changes.
> 
> > and I was requested to write this patch by Daniel Walker (final mail 
> > wasn't on the ml):
> > 
> > http://lkml.org/lkml/2009/9/14/183
> 
> This is something slightly different -- he asks you to fixup whitespace 
> issue in the code you are newly introducing, right?
> 
> > > And after today's discussion on kernel summit on this topic, I wouldn't
> > > expect any maintainer to merge it, sorry :)
> > What are you talking about?
> 
> Seems like many kernel maintainers are just tired of 
> 'whitespace-cleanup-only' patches that bring no real added value 
> otherwise.

May be some are tired, but others just say thanks and apply them,
because it is easier to apply than complain, and because they do not
mind if their subsystem becomes a tiny bit cleaner. Sometimes it may
cause troubles, but hey, development is not easy and we are accustomed
to fix conflict and amend patches. But the include/acpi/actypes.h does
not seem to be changing very often anyway.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

