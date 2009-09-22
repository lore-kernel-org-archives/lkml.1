Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZIVQxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZIVQxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZIVQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:53:38 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:55231 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966AbZIVQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:53:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Tue, 22 Sep 2009 18:53:38 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com> <200909201509.14794.elendil@planet.nl> <31cb94fa0909220743w6c512075ve69ec292b37a079a@mail.gmail.com>
In-Reply-To: <31cb94fa0909220743w6c512075ve69ec292b37a079a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221853.40148.elendil@planet.nl>
X-OriginalArrivalTime: 22 Sep 2009 16:53:40.0744 (UTC) FILETIME=[3CB24880:01CA3BA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Wei Chong Tan wrote:
> > That still given me an arm instead of an armel package.
>
> dpkg-architecture seems to set a bunch of build-time environment
> variable, could it be there one is not set by default for arm vs
> armel?

dpkg-gencontrol, if left alone, seems to understand about cross-compiling 
*and* understand the difference between compiling for arm and armel, while 
dpkg-architecture seems to ignore that. But I really don't know enough 
about either to be able to say what the exact problem is or what the 
correct solution is here.

All I can tell you is that when I cross-compile for armel (on a Debian 
amd64/Lenny host system) with very simply the following set in the 
environment, it all magically works correctly:
   export ARCH=arm
   export CROSS_COMPILE=arm-linux-gnueabi-

I don't think we should lose correct automatic detection for the sake of 
fixing your use case.

I would suggest asking for advice on the debian-devel mailing list or, 
maybe even better, from the dpkg maintainers.

Cheers,
FJP
