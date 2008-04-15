Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYDOUIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYDOUIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765971AbYDOUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:07:49 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:59372 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761578AbYDOUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KbUSLKZMdTAdq89qVVN/B8LvqBT3TmSQwuw5t8GVEL9BGA47T7j8Cvw2xo+lVGWEUG73VAAUv5bPxoDXqr740boylu6xr1mVxQpE+hDXrRwDnJgX7PUvQrAPJg66ygmqZ2vDhMccTnCNyHx8avuBDh/FCNPJlJCPe7qSm3mc1Gk=
Subject: Re: [PATCH] crypto: padlock-aes.c replace private copy of bit
	rotation routines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
In-Reply-To: <20080415130541.4123b8a3.akpm@linux-foundation.org>
References: <1208286963.11920.90.camel@brick>
	 <20080415130541.4123b8a3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 13:07:51 -0700
Message-Id: <1208290071.11920.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 13:05 -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 12:16:03 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Use the generic kernel implementation of the bit-rotation routines.
> > The generic routines to not shift by mod 32, but all callers in the
> > file pass constant values less than 32 making this a non-issue.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  drivers/crypto/padlock-aes.c |   19 +++----------------
> 
> git-cryptodev.patch has taken a big chainsaw to the code which you're
> patching.
> 

No worries, I'll wait for the crypto merge and see if this is still
there.

Harvey

