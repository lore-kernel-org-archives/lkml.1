Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbXJZVSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbXJZVSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbXJZVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:17:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760177AbXJZVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:17:52 -0400
Date: Fri, 26 Oct 2007 14:13:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071026141358.38342c0f@laptopd505.fenrus.org>
In-Reply-To: <200710262244.57147.agruen@suse.de>
References: <20071026064024.243943043@suse.de>
	<20071026073721.618b4778@laptopd505.fenrus.org>
	<200710262244.57147.agruen@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 22:44:56 +0200
Andreas Gruenbacher <agruen@suse.de> wrote:

> On Friday 26 October 2007 16:37, Arjan van de Ven wrote:
> > In addition, I'd like to ask you to put a file in Documentation/
> > somewhere that describes what AppArmor is intended security
> > protection is (it's different from SELinux for sure for example);
> > by having such a document for each LSM user, end users and distros
> > can make a more informed decision which module suits their
> > requirements... and it also makes it possible to look at the
> > implementation to see if it has gaps to the intent, without getting
> > into a pissing contest about which security model is better; but
> > unless the security goals are explicitly described that's a trap
> > that will keep coming back... so please spend some time on getting
> > a good description going here..
> 
> Hmm, I agree that it makes sense to give a short overview of each
> LSM. A description of the AppArmor model and implementation can be
> found in the directory that John referred to actually. I'm unsure how
> much of that makes sense under Documentation/ -- what do you think? 
> 
>  http://forgeftp.novell.com/apparmor/LKML_Submission-Oct-07/techdoc.pdf
> 
> I guess actual end user information doesn't belong in the kernel
> sources; that really seems wrong.
> 

My main concern for now is a description of what it tries to protect
against/in what cases you would expect to use it. THe reason for asking
this explicitly is simple: Until now the LSM discussions always ended
up in a nasty mixed up mess around disagreeing on the theoretical model
of what to protect against and the actual implementation of the threat
protection. THe only way I can think of to get out of this mess is to
have the submitter of the security model give a description of what his
protection model is (and unless it's silly, not argue about that), and
then only focus on how the code manages to achieve this model, to make
sure there's no big gaps in it, within its own goals/reference.

On the first part (discussion of the model) I doubt we can get people
to agree, that's pretty much phylosophical... on the second part (how
well the code/design lives up to its own goals) the analysis can be
objective and technical.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
