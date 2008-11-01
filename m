Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYKAQ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYKAQ11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYKAQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:27:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:37624 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYKAQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=I7gXAU4Rsb2nqgT0HZRddPvFyfEbsylJo5950XcZOcNi/rmuMaJ5ANHZ1Gjp50fjZQ
         5THj9YsnUa1lJByN5YaZs9FqPAmGEPVEIwS6/DwfMH5hcwsK3E9wk5qs36cbvVPEc/vS
         tnkf774qg8ewDfAsQCR71W+7C2pQ4rjaleexc=
Message-ID: <84144f020811010927o2d006058t89ba64363567ecc5@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:27:17 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
Cc: "Devin Heitmueller" <devin.heitmueller@gmail.com>,
       "Markus Rechberger" <mrechberger@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
In-Reply-To: <200811011721.46016.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	 <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	 <200811011721.46016.hverkuil@xs4all.nl>
X-Google-Sender-Auth: 2a0ae63dab6e42c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 6:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> At this time I do not advocate replacing the current em28xx driver. But
> when they are both in the kernel, then I expect and hope that the best
> features of the em28xx driver are merged into the empia driver and that
> the current em28xx driver can eventually be dropped.

We've done that many times and it usually ends up with us dragging the
old driver along for a very long time (look at the eepro100 driver
removal as an example). So you really want to just incrementally fix
up em28xx driver to avoid a mess.
