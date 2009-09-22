Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZIVOis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZIVOis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZIVOip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:38:45 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:51569 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686AbZIVOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:38:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Tue, 22 Sep 2009 16:38:45 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com> <200909201509.14794.elendil@planet.nl> <200909220238.17579.elendil@planet.nl>
In-Reply-To: <200909220238.17579.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221638.46767.elendil@planet.nl>
X-OriginalArrivalTime: 22 Sep 2009 14:38:46.0929 (UTC) FILETIME=[64682010:01CA3B92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Frans Pop wrote:
> On Sunday 20 September 2009, Frans Pop wrote:
> > So, somehow dpkg is able to do the right thing based on what is set
> > for gcc (I expect from the CROSS_COMPILE option), but not if that gets
> > overruled as both your patches seem to be doing.
>
> Actually, I think the correct way to build a linux kernel for i386 on an
> amd64 [1] system is to use 'linux32 make deb-pkg' [2]. With that no
> changes to the kernel build system should be needed at all, and I think
> with that you even should not need to set the ARCH variable.

I've tried it now and unfortunately this does not work either.
It works perfectly for the kernel build itself, but has no effect on the 
package that is created, so you still get an amd64 package.

:-(
