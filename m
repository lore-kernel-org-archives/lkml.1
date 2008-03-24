Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYCXXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYCXXz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYCXXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:55:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:10680 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYCXXzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mGqzBtrjXht/mpnAfQvSmiBHTFQVGMI7jUCmU/rHGzOveOc0vzEIKcrGrEXFboilKYrNLaiMuMgIyV+OpcRP8v4k/gZO65yzyq61f9gx2SxIy+uytUB41mbPEytbEe/K6T523tK4/nA2enKjCF4wb/F+YLozTyWlttXoePLqiKE=
Message-ID: <b0943d9e0803241655s7a7fea9cvcd3c162253e49625@mail.gmail.com>
Date: Mon, 24 Mar 2008 23:55:39 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Junio C Hamano" <gitster@pobox.com>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, git <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Josef Sipek" <jsipek@fsl.cs.sunysb.edu>
In-Reply-To: <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com>
	 <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr>
	 <47E81037.5030808@keyaccess.nl>
	 <7vlk47ua3v.fsf@gitster.siamese.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/2008, Junio C Hamano <gitster@pobox.com> wrote:
> Rene Herman <rene.herman@keyaccess.nl> writes:
>  > And I remember some mumblings about git growing quilt-like
>  > functionality itself. Anything on that?
>
>
> Not my mumbling, but I am quite open to slurp in guilt as a subdirectory
>  in git.git at some point in the future just like we bundle git-gui and
>  gitk if asked by the maintainer.
>
>  The same applies to StGIT for that matter, although I somehow feel that is
>  much less likely to happen, because it lived long enough as a standalone
>  project with enough following to achieve sustainable momentum by itself.

Indeed, StGIT has grown quite a lot (it now has ~45 commands) and it
probably feels better as a tool on its own. However, I think it would
be good for git to get such functionality (and it could even share
some ideas StGIT and guilt). If this functionality will get fully
integrated in git, StGIT could use it directly rather than the
low-level git commands.

An example of additional functionality that might stay outside of git
(at least for a while): since basic patch management support is pretty
much complete in StGIT, a feature we are thinking about adding is
better support for patch sharing between developers (or
repositories/branches). This should allow easier cloning and merging
with branches that have a volatile history at the top.

-- 
Catalin
