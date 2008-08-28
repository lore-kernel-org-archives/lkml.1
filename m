Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYH1R7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYH1R7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYH1R7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:59:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43286 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYH1R7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qjMzuGb6yR2znZRpJKYJdJti7tFYNuZR8Ez4B/YIklsnl7jEFcMZcNEtgPkT8Ny12K
         jh8wU1o8hz32i10P2B0JgP1NpJZmSON5qGr9QARPnbW35ge3AvRoc/tnIc2ENGq+dIXc
         Zf+GK0HPKsmYf5NfTvvqopktkVWAU5sdSGiCI=
Message-ID: <a4e6962a0808281059u68acad11v575df9031e6a2f3b@mail.gmail.com>
Date: Thu, 28 Aug 2008 12:59:12 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 14/59] CRED: Wrap task credential accesses in 9P2000 filesystem
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Serge Hallyn" <serue@us.ibm.com>, "Ron Minnich" <rminnich@sandia.gov>,
       "Latchesar Ionkov" <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20080827134654.19980.45849.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	 <20080827134654.19980.45849.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 8:46 AM, David Howells <dhowells@redhat.com> wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
>
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
>
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: Eric Van Hensbergen <ericvh@gmail.com>
Reviewed-by: Eric Van Hensbergen <ericvh@gmail.com>
