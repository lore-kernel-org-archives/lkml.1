Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXFCGbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXFCGbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXFCGaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:30:55 -0400
Received: from gw.goop.org ([64.81.55.164]:36146 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbXFCGaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:30:55 -0400
Message-ID: <46626019.3070807@goop.org>
Date: Sat, 02 Jun 2007 23:30:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan> <4661F511.4070207@goop.org> <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan> <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> Just for the record, you mean this one:
> http://lkml.org/lkml/2007/5/12/93   ..right? (haven't been bitten by
> this one...yet)

That's the one.  It's fairly subtle; there's no metadata/filesystem
corruption, and the file just reverts back to a previous length, so if
it were append-only, it would just return to a previous state.

    J
