Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbXKFX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbXKFX1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXKFX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:27:16 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34252 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753265AbXKFX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:27:15 -0500
Date: Wed, 7 Nov 2007 00:26:51 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Patch tags [was writeout stalls in current -git]
Message-ID: <20071106232651.GP26163@stusta.de>
References: <20071105155749.73e0e38e.akpm@linux-foundation.org> <28448.1194366312@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <28448.1194366312@lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 09:25:12AM -0700, Jonathan Corbet wrote:
> Andrew wrote:
> 
> > > Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
> > 
> > I would prefer Tested-by: :(
> 
> This seems like as good an opportunity as any to toss my patch tags
> document out there one more time.  I still think it's a good idea to
> codify some sort of consensus on what these tags mean... 

What's missing is a definition which of them are formal tags that must 
be explicitely given (look at point 13 in SubmittingPatches).

Signed-off-by: and Reviewed-by: are the formal tags someone must have 
explicitely given and that correspond to some statement.

OTOH, I can translate a "sounds fine" or "works for me" someone else 
gave me into an Acked-by: resp. Tested-by: tag.

> jon
>...
> --- /dev/null
> +++ b/Documentation/patch-tags
> @@ -0,0 +1,76 @@
> +Patches headed for the mainline may contain a variety of tags documenting
> +who played a hand in (or was at least aware of) their progress.  All of
> +these tags have the form:
> +
> +	Something-done-by: Full name <email@address> [optional random stuff]
> +
> +These tags are:
> +
> +From: 	   	The original author of the patch.  This tag will ensure
> +		that credit is properly given when somebody other than the
> +		original author submits the patch.
> +
> +Signed-off-by:	A person adding a Signed-off-by tag is attesting that the
> +		patch is, to the best of his or her knowledge, legally able
> +		to be merged into the mainline and distributed under the
> +		terms of the GNU General Public License, version 2.  See
> +		the Developer's Certificate of Origin, found in
> +		Documentation/SubmittingPatches, for the precise meaning of
> +		Signed-off-by.  This tag assures upstream maintainers that
> +		the provenance of the patch is known and allows the origin
> +		of the patch to be reviewed should copyright questions
> +		arise.
> +
> +Acked-by:	The person named (who should be an active developer in the
> +		area addressed by the patch) is aware of the patch and has
> +		no objection to its inclusion; it informs upstream
> +		maintainers that a certain degree of consensus on the patch
> +		as been achieved..  An Acked-by tag does not imply any
> +		involvement in the development of the patch or that a
> +		detailed review was done. 
> +
> +Reviewed-by:	The patch has been reviewed and found acceptable according
> +		to the Reviewer's Statement as found at the bottom of this
> +		file.  A Reviewed-by tag is a statement of opinion that the
> +		patch is an appropriate modification of the kernel without
> +		any remaining serious technical issues.  Any interested
> +		reviewer (who has done the work) can offer a Reviewed-by
> +		tag for a patch.  This tag serves to give credit to
> +		reviewers and to inform maintainers of the degree of review
> +		which has been done on the patch.
> +
> +Cc:		The person named was given the opportunity to comment on
> +		the patch.  This is the only tag which might be added
> +		without an explicit action by the person it names.  This
> +		tag documents that potentially interested parties have been
> +		included in the discussion.
> +
> +Tested-by:	The patch has been successfully tested (in some
> +		environment) by the person named.  This tag informs
> +		maintainers that some testing has been performed, provides
> +		a means to locate testers for future patches, and ensures
> +		credit for the testers.
> +
> +
> +----
> +
> +Reviewer's statement of oversight, v0.02
> +
> +By offering my Reviewed-by: tag, I state that:
> +
> + (a) I have carried out a technical review of this patch to evaluate its
> +     appropriateness and readiness for inclusion into the mainline kernel. 
> +
> + (b) Any problems, concerns, or questions relating to the patch have been
> +     communicated back to the submitter.  I am satisfied with the
> +     submitter's response to my comments.
> +
> + (c) While there may be things that could be improved with this submission,
> +     I believe that it is, at this time, (1) a worthwhile modification to
> +     the kernel, and (2) free of known issues which would argue against its
> +     inclusion.
> +
> + (d) While I have reviewed the patch and believe it to be sound, I do not
> +     (unless explicitly stated elsewhere) make any warranties or guarantees
> +     that it will achieve its stated purpose or function properly in any
> +     given situation.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

