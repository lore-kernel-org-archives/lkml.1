Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXJIAFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXJIAFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXJIAFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:05:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:44183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbXJIAFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:05:44 -0400
From: Neil Brown <neilb@suse.de>
To: corbet@lwn.net (Jonathan Corbet)
Date: Tue, 9 Oct 2007 10:05:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18186.50640.970552.719041@notabene.brown>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight 
In-Reply-To: message from Jonathan Corbet on Monday October 8
References: <20071008173706.GA12026@uranus.ravnborg.org>
	<10940.1191883390@lwn.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday October 8, corbet@lwn.net wrote:

I find it is always good to know *why* we have the tags.  That
information is a useful complement to what they mean, and can guide
people in adding them.

So below I present some "Purposes", YetAnotherTag, and a comment on
the RSO.

(And I'd like to add a vote for "Blame-Shared-By:" rather than
"Reviewed-by:", however I don't I'll get much support...)

> diff --git a/Documentation/patch-tags b/Documentation/patch-tags
> new file mode 100644
> index 0000000..fb5f8e1
> --- /dev/null
> +++ b/Documentation/patch-tags
> @@ -0,0 +1,66 @@
> +Patches headed for the mainline may contain a variety of tags documenting
> +who played a hand in (or was at least aware of) its progress.  All of these
> +tags have the form:
> +
> +	Something-done-by: Full name <email@address>
> +
> +These tags are:

   From:        The Author, Primary Author, or Authors of the patch.
                Authors should also provide a Signed-off-by: tag.

                Purpose: to give credit to authors
> +
> +Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
> +		patch is, to the best of his or her knowledge, legally able
> +		to be merged into the mainline and distributed under the
> +		terms of the GNU General Public License, version 2.  See
> +		the Developer's Certificate of Origin, found in
> +		Documentation/SubmittingPatches, for the precise meaning of
> +		Signed-off-by.

                Purpose: to allow subsequent review of the originality of 
                the contribution should copyright questions arise.
> +
> +Acked-by:	The person named (who should be an active developer in the
> +		area addressed by the patch) is aware of the patch and has
> +		no objection to its inclusion.  An Acked-by tag does not
> +		imply any involvement in the development of the patch or
> +		that a detailed review was done.

                Purpose:  to inform upstream aggregators that
		consensus was achieved for the change.  This is
		particularly relevant for changes that affect multiple
		Maintenance Domains.

> +
> +Reviewed-by:	The patch has been reviewed and found acceptible according
> +		to the Reviewer's Statement as found at the bottom of this
> +		file.  A Reviewed-by tag is a statement of opinion that the
> +		patch is an appropriate modification of the kernel without
> +		any remaining serious technical issues.  Any interested
> +		reviewer (who has done the work) can offer a Reviewed-by
> +		tag for a patch.

		Purpose: to inform upstream aggregators that due
		diligence has been performed to ensure correctness of
		the change.  Also to give credit to reviewers.

> +
> +Cc:		The person named was given the opportunity to comment on
> +		the patch.  This is the only tag which might be added
> +		without an explicit action by the person it names.

		Purpose: to ensure that interested parties are
		included in subsequent discussions of the change.

> +
> +Tested-by:	The patch has been successfully tested (in some
> +		environment) by the person named.

		Purpose: to give credit to testers.

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
> +     communicated back to the submitter.  I am satisfied with how the
> +     submitter has responded to my comments.

This seems more detailed that necessary.  The process (communicated
back / responded) is not really relevant.  I would go for something
like:

    (b) I have no outstanding problems, concerns, or questions about
        this patch (except as noted in the above comments).

and in fact, given (c2), (b) might not be needed at all.

NeilBrown


> +
> + (c) While there may (or may not) be things which could be improved with
> +     this submission, I believe that it is, at this time, (1) a worthwhile
> +     modification to the kernel, and (2) free of known issues which would
> +     argue against its inclusion.
> +
> + (d) While I have reviewed the patch and believe it to be sound, I can not
> +     (unless explicitly stated elsewhere) make any warranties or guarantees
> +     that it will achieve its stated purpose or function properly in any
> +     given situation.
> +
> + (e) I understand and agree that this project and the contribution are
> +     public and that a record of the contribution (including my Reviewed-by
> +     tag and any associated public communications) is maintained
> +     indefinitely and may be redistributed consistent with this project or
> +     the open source license(s) involved.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
