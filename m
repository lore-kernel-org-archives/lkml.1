Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYJXTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYJXTde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYJXTd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:33:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43576 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYJXTd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:33:26 -0400
Date: Fri, 24 Oct 2008 14:18:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Message-ID: <20081024191813.GA27505@us.ibm.com>
References: <20081024174838.GA24466@us.ibm.com> <11290.1224873841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11290.1224873841@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > I've just tested with David's plain creds-v3 tree
> 
> Note the creds-v4 branch is now current.  Is it worth me replacing that with a
> tree that just has a master branch to simplify things?

I saw it in your list of branches, but linux-next/Next/Trees still
listed v3 so i figured i should test against that.

> > -	struct user_namespace *ns = current->nsproxy->user_ns;
> > +	struct user_namespace *ns = current_user()->user_ns;
> 
> current_user_ns() perchance?

Yes, thanks.  (Of course that doesn't break anything so if the patch is
otherwise ok i've written down a note to send a follow-up patch)

thanks,
-serge
