Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZD2Mju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZD2Mju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbZD2Mje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:39:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbZD2Mjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:39:33 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips mode
Date: Wed, 29 Apr 2009 08:38:45 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200904282111.52074.jarod@redhat.com> <20090429103623.GB7227@hmsreliant.think-freely.org>
In-Reply-To: <20090429103623.GB7227@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904290838.45896.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 06:36:23 Neil Horman wrote:
> On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> > I think this might have already been posted by Neil Horman, and
> > we already have it in the Red Hat Enterprise Linux 5.x kernels,
> > but in fips mode, we need to panic on the base cipher self-tests
> > failing as well as the later tests.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> I did post it:
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg02307.html
> looks like it somehow just never made it to Linus.  Thanks for noticing, Jarod.

That part got committed, this is an additional piece, as I believe that
wasn't quite complete. This patch adds another check for the rc of
alg_test_cipher() (vs. only the check for alg_test_descs[i].test()).

-- 
Jarod Wilson
jarod@redhat.com
