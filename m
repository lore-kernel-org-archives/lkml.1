Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYFNWJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYFNWJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYFNWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:09:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:5323 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYFNWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MZYkgQgjrZmfyH5aEnepnzaxtPwSd532IK9nKThb9blj2sfZLI+UKqfGOs8DMwGFPi
         Rvdxb9+TMwkfeXaJFtBNV7FY6tpFThKKavjLzdJquvVQz/5haHh1w4nHF7ODFs3OIlBz
         UuugUKO6F3p//aqr/wkBMQgXRHjSEkhe3xvqU=
Message-ID: <19f34abd0806141509m18f9f959v94fbeb27e42aa0ed@mail.gmail.com>
Date: Sun, 15 Jun 2008 00:09:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 10:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> If you know of any other unresolved regressions from 2.6.25, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.

http://lkml.org/lkml/2008/6/14/62

was just reported today. Seems to have been caused by

commit 3ac7fe5a4aab409bd5674d0b070bce97f9d20872
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Apr 30 00:55:01 2008 -0700

    infrastructure to debug (dynamic) objects

which was introduced just after v2.6.25, but not discovered until now,
probably because it requires the (admittedly obscure) combination of
lockdep and slub/object debugging.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
