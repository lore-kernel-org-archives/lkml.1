Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbXHGOTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbXHGOTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbXHGOTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:19:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbXHGOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:19:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46B87590.60208@t-online.de>
References: <46B87590.60208@t-online.de> <23249.1186492623@redhat.com> <46B86FC1.7050601@t-online.de> <46695F6D.5050600@t-online.de> <8772.1186149811@redhat.com> <23350.1186492903@redhat.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH] NOMMU: Separate out VMAs
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 07 Aug 2007 15:03:34 +0100
Message-ID: <25818.1186495414@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> This probably wants to be dependent on something like MAP_TRIM_EXCESS.

Hmmm...  In the interests of not adding more flags, I wonder if mremap()
should be used for that, with a global setting for mmaps made by binfmts as
they can't really be shrunk afterwards if they're shareable.

David
