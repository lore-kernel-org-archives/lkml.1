Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXDDAfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXDDAfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934045AbXDDAfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:35:33 -0400
Received: from gw.goop.org ([64.81.55.164]:46259 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934044AbXDDAfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:35:32 -0400
Message-ID: <4612F2BF.7080704@goop.org>
Date: Tue, 03 Apr 2007 17:35:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com>
In-Reply-To: <4612F1F0.5070209@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Sounds like it would need a device which can be waited upon for changes.

A vdso-like shared page could have a futex in it.

    J
