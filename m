Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYGICh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYGICh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 22:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGIChw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 22:37:52 -0400
Received: from waste.org ([66.93.16.53]:54318 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYGIChv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 22:37:51 -0400
Subject: Re: LKML mercurial repository borked
From: Matt Mackall <mpm@selenic.com>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, "Bryan O'Sullivan" <bos@serpentine.com>
In-Reply-To: <20080708213131.1afb7314.pj@sgi.com>
References: <20080708213131.1afb7314.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 21:37:00 -0500
Message-Id: <1215571020.11311.246.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-08 at 21:31 -0500, Paul Jackson wrote:
> The lkml mercurial (hg) repository at:
> 
>   http://www.kernel.org/hg/linux-2.6
> 
> is borked.
> 
> Trying to "hg pull" from it fails quickly, with:
> 
>   pulling from http://www.kernel.org/hg/linux-2.6
>   abort: 'http://www.kernel.org/hg/linux-2.6' does not appear to be an hg repository!
> 
> Going to 'http://www.kernel.org/hg/linux-2.6' with a web browser fills
> ones browser screen with a RevlogError from some Python script.
> 
> The backdoor http://master.kernel.org/hg/linux-2.6 still works,
> so my local configuration and installation of python and mercurial
> is apparently not messed up.  However we are not supposed to use
> that backdoor normally, as it has much less bandwidth (to quote
> a two year old message I have from Bryan, the last time something
> like this happened.)

Known problem from Python version skew between servers. Should be
resolved soon.

-- 
Mathematics is the supreme nostalgia of our time.

