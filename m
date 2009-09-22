Return-Path: <linux-kernel-owner+w=401wt.eu-S1750995AbZIVAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbZIVAiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZIVAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:38:15 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:59559 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbZIVAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:38:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Tue, 22 Sep 2009 02:38:16 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com> <31cb94fa0909172010v1af9b528vcad5fefbf75341e9@mail.gmail.com> <200909201509.14794.elendil@planet.nl>
In-Reply-To: <200909201509.14794.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909220238.17579.elendil@planet.nl>
X-OriginalArrivalTime: 22 Sep 2009 00:38:18.0003 (UTC) FILETIME=[FA6CAE30:01CA3B1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 September 2009, Frans Pop wrote:
> So, somehow dpkg is able to do the right thing based on what is set for
> gcc (I expect from the CROSS_COMPILE option), but not if that gets
> overruled as both your patches seem to be doing.

Actually, I think the correct way to build a linux kernel for i386 on an 
amd64 [1] system is to use 'linux32 make deb-pkg' [2]. With that no 
changes to the kernel build system should be needed at all, and I think 
with that you even should not need to set the ARCH variable.

It should also be possible to build a 64-bit kernel for i386 on amd64 that 
way using 'linux32 make ARCH=x86_64 deb-pkg'.

Untested, but AFAIK that should work. Sorry for not mentioning it earlier, 
but it's a command I've never really used myself and I keep forgetting 
about it :-/

Cheers,
FJP

[1] amd64 as in the Debian architecture, which also covers Intel 64-bit
[2] linux32 is in until-linux package and thus guaranteed to be available
