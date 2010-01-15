Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115Ab0AOAls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0AOAls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137Ab0AOAlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:41:47 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:50767 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0AOAlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ppXK7dDtodFAbTuj/8WY9kzwrWYbK6GISzJoHj6oI6BrUFgo9IMMLgvaHfansRoILP
         U71WFd0z1AQCa39NotzAbNuXyiMY849JRzZT3ebBCohLT82uEZ0deM9SN/5Tyn19jwRi
         CO6pV+REhrBR9VBgtgAn+ODUObfAN97f1lJb8=
MIME-Version: 1.0
In-Reply-To: <tkrat.e8ba67441fb65247@s5r6.in-berlin.de>
References: <4B4F7304.5050401@s5r6.in-berlin.de>
	 <Pine.LNX.4.30.1001141303230.3979-100000@mail.perches.com>
	 <tkrat.e8ba67441fb65247@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 01:41:44 +0100
Message-ID: <9b06e8d21001141641u31c62480q706ed4fe122c7c20@mail.gmail.com>
Subject: Re: [PATCH] HOWTO: Updates on subsystem trees, patchwork, -next (vs. 
	-mm)
From: =?ISO-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/14 Stefan Richter <stefanr@s5r6.in-berlin.de>:
> One of the roles which -mm fulfilled some time ago (to offer an
> integration testing ground) has been taken over by -next.  This is still
> news to Documentation/HOWTO, so mention it there.
>
> Also add a word on how patchwork is used to track patches as they make
> their way into subsystem trees.  Remove some arbitrary links to
> subsystem repositories; they can all be found in the MAINTAINERS
> database.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> This supersedes
> [PATCH] HOWTO: Point to patchwork.kernel.org and patchwork.ozlabs.org
>
>  Documentation/HOWTO |  112 ++++++++++++++++-----------------------------------
>  1 files changed, 35 insertions(+), 77 deletions(-)
>
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 8495fc9..085d281 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -221,8 +221,8 @@ branches.  These different branches are:
>   - main 2.6.x kernel tree
>   - 2.6.x.y -stable kernel tree
>   - 2.6.x -git kernel patches
> -  - 2.6.x -mm kernel patches
>   - subsystem specific kernel trees and patches
> +  - the 2.6.x -next kernel tree for integration tests
>
>  2.6.x kernel tree
>  -----------------
> @@ -232,7 +232,7 @@ process is as follows:
>   - As soon as a new kernel is released a two weeks window is open,
>     during this period of time maintainers can submit big diffs to
>     Linus, usually the patches that have already been included in the
> -    -mm kernel for a few weeks.  The preferred way to submit big changes
> +    -next kernel for a few weeks.  The preferred way to submit big changes
>     is using git (the kernel's source management tool, more information
>     can be found at http://git.or.cz/) but plain patches are also just
>     fine.
> @@ -293,84 +293,42 @@ daily and represent the current state of Linus' tree.  They are more
>  experimental than -rc kernels since they are generated automatically
>  without even a cursory glance to see if they are sane.
>
> -2.6.x -mm kernel patches
> -------------------------
> -These are experimental kernel patches released by Andrew Morton.  Andrew
> -takes all of the different subsystem kernel trees and patches and mushes
> -them together, along with a lot of patches that have been plucked from
> -the linux-kernel mailing list.  This tree serves as a proving ground for
> -new features and patches.  Once a patch has proved its worth in -mm for
> -a while Andrew or the subsystem maintainer pushes it on to Linus for
> -inclusion in mainline.
> -
> -It is heavily encouraged that all new patches get tested in the -mm tree
> -before they are sent to Linus for inclusion in the main kernel tree.  Code
> -which does not make an appearance in -mm before the opening of the merge
> -window will prove hard to merge into the mainline.
> -
> -These kernels are not appropriate for use on systems that are supposed
> -to be stable and they are more risky to run than any of the other
> -branches.
> -
> -If you wish to help out with the kernel development process, please test
> -and use these kernel releases and provide feedback to the linux-kernel
> -mailing list if you have any problems, and if everything works properly.
> -
> -In addition to all the other experimental patches, these kernels usually
> -also contain any changes in the mainline -git kernels available at the
> -time of release.
> -
> -The -mm kernels are not released on a fixed schedule, but usually a few
> --mm kernels are released in between each -rc kernel (1 to 3 is common).
> -
>  Subsystem Specific kernel trees and patches
>  -------------------------------------------
> -A number of the different kernel subsystem developers expose their
> -development trees so that others can see what is happening in the
> -different areas of the kernel.  These trees are pulled into the -mm
> -kernel releases as described above.
> -
> -Here is a list of some of the different kernel trees available:
> -  git trees:
> -    - Kbuild development tree, Sam Ravnborg <sam@ravnborg.org>
> -       git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
> -
> -    - ACPI development tree, Len Brown <len.brown@intel.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> -
> -    - Block development tree, Jens Axboe <jens.axboe@oracle.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> -
> -    - DRM development tree, Dave Airlie <airlied@linux.ie>
> -       git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> -
> -    - ia64 development tree, Tony Luck <tony.luck@intel.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
> -
> -    - infiniband, Roland Dreier <rolandd@cisco.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
> -
> -    - libata, Jeff Garzik <jgarzik@pobox.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> -
> -    - network drivers, Jeff Garzik <jgarzik@pobox.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
> -
> -    - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
> -       git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> -
> -    - SCSI, James Bottomley <James.Bottomley@hansenpartnership.com>
> -       git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> -
> -    - x86, Ingo Molnar <mingo@elte.hu>
> -       git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> -
> -  quilt trees:
> -    - USB, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
> -       kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> +The maintainers of the various kernel subsystems --- and also many
> +kernel subsystem developers --- expose their current state of
> +development in source repositories.  That way, others can see what is
> +happening in the different areas of the kernel.  In areas where
> +development is rapid, a developer may be asked to base his submissions
> +onto such a subsystem kernel tree so that conflicts between the
> +submission and other already ongoing work are avoided.
> +
> +Most of these repositories are git trees, but there are also other SCMs
> +in use, or patch queues being published as quilt series.  Addresses of
> +these subsystem repositories are listed in the MAINTAINERS file.
> +
> +Before a proposed patch is committed to such a subsystem tree, it is
> +subject to review which primarily happens on the on mailing lists (see

    There is a small typo "on the on".

> +the respective section below).  For several kernel subsystems, this
> +submission and review process is tracked with the tool patchwork.
> +Patchwork offers a web interface which shows patch postings, any
> +comments on a patch or revisions to it, and maintainers can mark patches
> +as under review, accepted, or rejected.  Most of these patchwork sites
> +are listed at http://patchwork.kernel.org/ or http://patchwork.ozlabs.org/.
> +
> +2.6.x -next kernel tree for integration tests
> +---------------------------------------------
> +Before updates from subsystem trees are merged into the mainline 2.6.x
> +tree, they need to be integration-tested.  For this purpose, a special
> +testing repository exists into which virtually all subsystem trees are
> +pulled on an almost daily basis:
> +       http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
> +       http://linux.f-seidel.de/linux-next/pmwiki/
> +
> +This way, the -next kernel gives a summary outlook onto what will be
> +expected to go into the mainline kernel at the next merge period.
> +Adventurous testers are very welcome to runtime-test the -next kernel.
>
> -  Other kernel trees can be found listed at http://git.kernel.org/ and in
> -  the MAINTAINERS file.
>
>  Bug Reporting
>  -------------
>
> --
> Stefan Richter
> -=====-==-=- ---= -===-
> http://arcgraph.de/sr/
>

     Loïc
