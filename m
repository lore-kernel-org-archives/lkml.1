Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYKLIk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYKLIk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYKLIkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:40:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:10651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKLIke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m1is1P3BAzT/OWZCFh+UxFRP5lIvvvUH2WGINLW0os5thrZo/LAJov6GyuEMWGCum0
         9Qcvts9KbA/svx71QNe2fPiOnbxjzrkcmpSCVpD34T8KMxyurPWYx/VRs07tQBWs3acw
         146U/n4frBr+V6fLb78w8ohiWjyW0ID08mK/I=
Message-ID: <c62985530811120040m7b017bf7qc596e2bd30463bb5@mail.gmail.com>
Date: Wed, 12 Nov 2008 09:40:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] boot tracer updates
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081112055454.798779203@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112055454.798779203@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Steven Rostedt <rostedt@goodmis.org>:
>
> Ingo,
>
> The following patches are in:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>
>    branch: tip/devel
>
>
> Frederic Weisbecker (2):
>      tracing/fastboot: Move boot tracer structs and funcs into their own header.
>      tracing/fastboot: Use the ring-buffer timestamp for initcall entries
>
> ----
>  include/linux/ftrace.h    |   41 ---------------
>  include/trace/boot.h      |   56 ++++++++++++++++++++
>  init/main.c               |   33 +++++++------
>  kernel/trace/trace.h      |   16 ++++--
>  kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
>  5 files changed, 179 insertions(+), 90 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


Hi Steven,

I didn't know that your tree was the new first repository for tracing.
Should I now send you all my tracing related
patches (including function return tracing?).

Thanks.
