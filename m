Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbXJKUu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbXJKUu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXJKUuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:50:19 -0400
Received: from pat.uio.no ([129.240.10.15]:39452 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbXJKUuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:50:17 -0400
Subject: Re: [PATCH] Documentation/patch-tags v3
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <30616.1192133818@lwn.net>
References: <30616.1192133818@lwn.net>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 16:50:11 -0400
Message-Id: <1192135811.7899.25.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.140)
X-UiO-Scanned: 410BF6124E17315E52C4A06BCD252D24EDBEC6D7
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 877 total 4441324 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-11 at 14:16 -0600, Jonathan Corbet wrote:
> Here's the current version of the patch-tags document; I've made changes
> in response to comments from a Randy Dunlap and Scott Preece.  The only
> substantive change, though, is the removal of the privacy term, since it
> really does seem to be overkill.  It can come back if it turns out to be
> truly needed.
> 
> Andrew, you've been quiet on this.  Does it correspond to your notion of
> what Reviewed-by should mean?  
> 
> jon
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 43e89b1..fa1518b 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -284,6 +284,8 @@ parport.txt
>  	- how to use the parallel-port driver.
>  parport-lowlevel.txt
>  	- description and usage of the low level parallel port functions.
> +patch-tags
> +	- description of the tags which can be added to patches
>  pci-error-recovery.txt
>  	- info on PCI error recovery.
>  pci.txt
> diff --git a/Documentation/patch-tags b/Documentation/patch-tags
> new file mode 100644
> index 0000000..6acde5e
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

Does 'Reviewed-by' also imply 'Signed-off-by'? In other words, who is
actually supposed to add this tag?

Is it the reviewer who passes on an officially 'reviewed' patch to the
maintainer, or is it the patch author him/herself who is responsible for
soliciting reviews and adding the tag?

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

Again. Who is supposed to add this?

> +----
> +
> +Reviewer's statement of oversight
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

I'm confused about how to reconcile (c) and (d) here. If you are not
sure about whether or not the patch will achieve its stated purpose, why
would you be arguing that it is a worthwhile modification?

Trond

