Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZINVBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZINVBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZINVBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:01:16 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:59286 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755781AbZINVBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:01:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Mon, 14 Sep 2009 23:01:16 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
In-Reply-To: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909142301.17936.elendil@planet.nl>
X-OriginalArrivalTime: 14 Sep 2009 21:01:18.0366 (UTC) FILETIME=[81397BE0:01CA357E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009, Wei Chong Tan wrote:
> I was using "make ARCH=i386 deb-pkg" in the kernel on a 64bit machine
> and found out that the .deb package created was _amd64.deb.
> Consequently, I modify the builddeb script to take into account the
> ARCH environment variable.

Thanks for the patch. I'd like to give it some testing though as I fear it 
may break one other use case that currently somehow does work correctly.

If I cross-compile for arm with EABI set in the config, the script 
currently correctly generates an armel package (probably through 
dpkg-cross).

Possibly your change would override that and change it to arm. I don't know 
for sure it will go wrong, but it does need testing. I'll let you know.

Cheers,
FJP
