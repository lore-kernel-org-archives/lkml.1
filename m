Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZKXKO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZKXKO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932555AbZKXKO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:14:26 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:64658 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZKXKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EUGmHbNZyceHI1yVIEvMGcIJixjzHZBEMn/S7+RDQp9VTL9SWpoqCUWzGuWDANWGkJ
         vBilpkowMlg6Mpt5/YGBTFMrWEudMA/N0tY3sSvX61qIK4WPTMa1zf4qyPttZ9OIpXZI
         ASk5UEJ7WFy+97I0zSO6DDJUIyHEeQGSLMXDM=
MIME-Version: 1.0
In-Reply-To: <1259055721.29729.277.camel@macbook.infradead.org>
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
	 <4B0BA71B.8040800@ladisch.de>
	 <1259055721.29729.277.camel@macbook.infradead.org>
Date: Tue, 24 Nov 2009 05:14:29 -0500
Message-ID: <806dafc20911240214x13838c9bma939c4a07ea25a82@mail.gmail.com>
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
From: Monty Montgomery <xiphmont@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Der Mickster <retroeffective@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where did the new firmware come from?

It is the firmware as originally appeared in in Tapio's original out
of tree driver in 2002-ish, was committed to the tree in 2.6.12, and
remained unchanged until it was removed in the firmware cleanup in
2.6.27.  The firmware header at that time held the bitstream, loader
and SPIDF/MIDI firmware images all in one header file.  In 2.6.27,
they were all split back out into their original ihex sources but this
operation seems to have been botched.  I wrote a quick script to
redump the data from the original header back into ihex format as I
couldn't locate the original ihex files Tapio apparently originally
worked from (the comments and partial original ihex inclusion in
Tapio's header are admittedly confusing and apparently led the
cleaner-upper astray).

Monty
