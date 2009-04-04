Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZDDIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZDDIpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZDDIpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:45:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:31431 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZDDIpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:45:39 -0400
Message-ID: <49D71E2B.5060501@larces.uece.br>
Date: Sat, 04 Apr 2009 05:45:31 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "Pavel Machek" <pavel@suse.cz>,
       "x86 Maintainers" <x86@kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH 0/6] x86: unify power/cpu_(32|64).c 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series intends to unify the cpu_32.c and cpu_64.c files.

It's divided into 6 patches, that deal with the following:
#1 - unify headers
#2 - unify global variables
#3 - unify saving of processor state
#4 - unify restoring of processor state
#5 - unify copyright notes on the files
#6 - unify the files themselves, leaving only cpu.c

The code generated is _exactly_ the same as before, on both  i386 and
x86-64 architectures, so I don't expect this to introduce _any_ new bugs.
However, cleanups can be done in future, as for instance, the removal
of a few global variables in the 32 bit architecture. We are not dealing 
with those in this series.

The patches are against 2.6.29.

Thanks,

Sergio.
