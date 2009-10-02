Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZJBRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZJBRiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZJBRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:38:08 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61607 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbZJBRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:38:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Trevor Hemsley <trevor.hemsley@ntlworld.com>
Subject: Re: Temperature above threshold loop with 2.6.31.1
Date: Fri, 2 Oct 2009 19:38:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20091002134430.SOPU22934.aamtaout04-winn.ispmail.ntl.com@trevor2.dsl.pipex.com> <200910021703.31679.elendil@planet.nl>
In-Reply-To: <200910021703.31679.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021938.09486.elendil@planet.nl>
X-OriginalArrivalTime: 02 Oct 2009 17:38:09.0695 (UTC) FILETIME=[1BA562F0:01CA4387]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Frans Pop wrote:
> Trevor Hemsley wrote:
> > 1,666 notifications a second seems a little on the 'too frequent' side
> > of things to me :-)
>
> Looks like this may already be fixed in mainline by the following
> commit: commit b417c9fd8690637f0c91479435ab3e2bf450c038
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Sep 22 15:50:24 2009 +0200
>     x86: mce: Fix thermal throttling message storm
>
> Can you confirm that please, either by compiling current git or by
> applying that commit on top of 2.6.31.1?

If you want to apply it to .31.1 you'll also need this commit:
commit 3967684006f30c253bc6d4a6604d1bad4a7fc672
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Sep 22 15:50:24 2009 +0200
    x86: mce: Clean up thermal throttling state tracking code
