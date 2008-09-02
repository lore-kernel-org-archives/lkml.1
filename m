Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYIBBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYIBBES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYIBBED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 21:04:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:11180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYIBBEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 21:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x8JEKNbY1ljqyEuz7j2jMw6n1Azj1sxMSk2UkDdYFwJv0J0lhfSmQX+epf0yErmMJJ
         hW+iFWpEcyf6MbYwMpCnNnaObwlQT+3V47v9ssABd5DAWzTAZKtKCeBgAIxHbfoKtWcK
         GCEfGwbglcWn64PDTtZrm+CbHQhsUv65FD4wI=
Message-ID: <21d7e9970809011803w775a66c5t5f77db5c4761dc0a@mail.gmail.com>
Date: Tue, 2 Sep 2008 11:03:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 09/59] CRED: Wrap task credential accesses in the DRM driver
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Serge Hallyn" <serue@us.ibm.com>
In-Reply-To: <20080827134628.19980.80653.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	 <20080827134628.19980.80653.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 11:46 PM, David Howells <dhowells@redhat.com> wrote:
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
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.sourceforge.net
> ---

Acked, and queued in drm-next tree.

Dave.
