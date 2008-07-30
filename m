Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYG3Uxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYG3Uxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYG3Uxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:53:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:25687 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYG3Uxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=R7/9q16Q8mC2tMVweczmJKMILHahuWhteigrKY6ZsYF03cei59lX3lSAQPQcRwT3vw
         x8wtBAD/CnEdBddwAjyVp1nnANhfWUaT3qBR+/BfmBUagfbqmGtMsArA2iFrvaETC5Gf
         SB3xq4u7BI+Ea2FH0QEbfCrnIAFKeV6thZgAQ=
Message-ID: <2f11576a0807301353h2d31f021m22b34d3a67e830c@mail.gmail.com>
Date: Thu, 31 Jul 2008 05:53:44 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Anders Johansson" <ajohansson@suse.de>
Subject: Re: [PATCH] making /proc/<pid>/limits writable
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200807302157.46261.ajohansson@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807302157.46261.ajohansson@suse.de>
X-Google-Sender-Auth: 66c1c6d284d26bdd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

> Attached is a patch making the limits for a process writable, so it is
> possible to change the limits of a task other than current.
>
> There are many reasons why this is desirable. The core limit is to me the most
> important. If a process hangs, because of some sort of race condition that
> happens once in a blue moon, and ulimit -c is set to 0, it might take forever
> to reproduce. It would be nice to be able to change that limit dynamically, to
> be able to get a core dump.
>
> Other limits should also be settable, but for now I've only done core size.

Hmm..
I agree to your motivation.

but I have two objection.
 - this interface is slightly ugly. end user can't lean easily.
 - you don't write any documentation nor patch description about how to use.
   So, I needed to read source code for know about how to use.
