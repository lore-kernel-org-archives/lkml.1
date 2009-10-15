Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZJOEnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZJOEnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 00:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZJOEnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 00:43:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2211 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZJOEnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 00:43:04 -0400
Subject: Re: [PATCH] scripts/get_maintainer.pl: add role output option
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1255578686.2488.228.camel@localhost>
References: <1255578686.2488.228.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 21:42:27 -0700
Message-Id: <1255581747.1851.167.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 04:51 +0100, Ben Hutchings wrote:
> Add the output option '--roles' to get_maintainer.pl.  This causes it
> to show the role of each email address, i.e. why it was selected.

Hi Ben.

Interesting idea.

This patch applies with offsets against the latest version
that Andrew Morton has in his tree.

Here are the patches I posted a few days ago:
http://lkml.org/lkml/2009/10/10/11

Are the email addresses generated going
to be acceptable to all mailers or is --roles
just used for visual inspection?

Have you tested it with
git-send-email --cc-cmd "scripts/get_maintainer.pl --roles" ?

Trivial comment:

> + push_email_address($line, 'signed-off');
[] 
> + push_email_address($line, 'blamed');

The "signed-off" role though isn't necessarily
an actual "Signed-off-by:".  It could be an
"Acked-by:", or "tested-by:", or "reviewed-By:".

And the "blamed" keyword may be unnecessarily negative.

Maybe it could be "git-signer" and "modified-author"

cheers, Joe

