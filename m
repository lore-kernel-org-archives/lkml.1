Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZITNJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZITNJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 09:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZITNJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 09:09:12 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:56244 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbZITNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 09:09:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Wei Chong Tan <weichong78@gmail.com>
Subject: Re: PATCH: ARCH in builddeb
Date: Sun, 20 Sep 2009 15:09:14 +0200
User-Agent: KMail/1.9.9
Cc: sam@ravnborg.org, max@stro.at, linux-kernel@vger.kernel.org
References: <31cb94fa0909132225l6cb98739o59d105ef480d1cd2@mail.gmail.com> <31cb94fa0909161712m3343812cw349b4a7233bda126@mail.gmail.com> <31cb94fa0909172010v1af9b528vcad5fefbf75341e9@mail.gmail.com>
In-Reply-To: <31cb94fa0909172010v1af9b528vcad5fefbf75341e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909201509.14794.elendil@planet.nl>
X-OriginalArrivalTime: 20 Sep 2009 13:09:15.0472 (UTC) FILETIME=[8DF15500:01CA39F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 September 2009, Wei Chong Tan wrote:
> How about this? Hopefully this would work for all arch supported.

That still given me an arm instead of an armel package.

I get the following from the deb-pkg target:
dpkg-architecture: warning: Specified GNU system type arm-linux-gnu does
not match gcc system type arm-linux-gnueabi.
dpkg-deb: building package `linux-image-2.6.31' in `../linux-image-2.6.31_6481.gc7572df_arm.deb'.

So, somehow dpkg is able to do the right thing based on what is set for gcc
(I expect from the CROSS_COMPILE option), but not if that gets overruled as
both your patches seem to be doing.

Cheers,
FJP
