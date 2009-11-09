Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZKINjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZKINjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZKINi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:38:58 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48396 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZKINi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Q/BBbgkOJ3OWZOqTumJav/V1C9g9JXGpmyPbSYWsE3YThBmL3LzRnjAh6OxwUAwlhT
         DRAWw9YCMUjyEpNNUY0h/xher07+fRDTSMDvZC95eYU5LJ79alLkRtWLUTrFPcyGw8oh
         5kALwCVFb0vYLFNSL0Uzel8yBSC5jDE09BfOg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: wireless tree build failure
Date: Mon, 9 Nov 2009 14:37:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091109190812.b2f75760.sfr@canb.auug.org.au>
In-Reply-To: <20091109190812.b2f75760.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091437.14465.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 09 November 2009 09:08:12 Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:

This was fixed yesterday by Hauke Mehrtens for wireless-testing
(http://patchwork.kernel.org/patch/58495/) and in the way preserving
bisectability in rt2800 tree.

Stephen, until someone explains me how they would like to coordinate
patch-flow w/ rt2800 tree please do not cc: me on rt2x00 patches as
I have completely no control over what people are doing with my patches
posted to linux-wireless for review.

[ Yesterday I've just noticed by accident (mail from Hauke) that older
  versions of my patches were merged into wireless-testing. ]

--
Bartlomiej Zolnierkiewicz
