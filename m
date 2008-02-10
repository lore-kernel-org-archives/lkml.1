Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYBJMyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYBJMyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYBJMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:54:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:28586 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbYBJMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u8WLUe2r1aTjGE9UsSOivAUIbsBBWTefuFLa/bXCk9zVLD6R8BNGFwETFMeKWHJKwZSTpouGfCuCwTRYaQUMR9XkPqfEYS78xSnjSMuKsjPof92m0l9qxfbAoOb8qBCIcp8GpKPrSlz9jGZRd9j3NmgXaPTbo2x+XouFTAxE4Bw=
Message-ID: <2e77fc10802100454q46056f89q2d591c3c1559d79c@mail.gmail.com>
Date: Sun, 10 Feb 2008 12:54:16 +0000
From: "Niki Denev" <ndenev@gmail.com>
To: "Bastian Blank" <bastian@waldi.eu.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
In-Reply-To: <20080210124731.GA25396@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
	 <20080210122250.GA24048@wavehammer.waldi.eu.org>
	 <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
	 <20080210124731.GA25396@wavehammer.waldi.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 12:47 PM, Bastian Blank <bastian@waldi.eu.org> wrote:
> On Sun, Feb 10, 2008 at 12:39:05PM +0000, Niki Denev wrote:
> > This patch is against 2.6.24.1 which has already the fix to vmsplice_to_user
> > With it i can't exploit the hole, and it is returns "invalid address"
>
> This is the vmsplice_to_pipe path and I have many reports that it is not
> fixed.
>
> Bastian

Exactly, my patch is for the the vmsplice_to_pipe path.
I don't guarantee correctness, but it stops the exploit in my environment.

Niki
