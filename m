Return-Path: <linux-kernel-owner+w=401wt.eu-S2992634AbXDDFWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992634AbXDDFWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992639AbXDDFWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:22:30 -0400
Received: from gw.goop.org ([64.81.55.164]:35909 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992634AbXDDFW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:22:29 -0400
Message-ID: <46133609.9060402@goop.org>
Date: Tue, 03 Apr 2007 22:22:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com> <4613330C.1020701@cosmosbay.com> <461334B5.7070607@zytor.com>
In-Reply-To: <461334B5.7070607@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mutable data should be separated from code.  I think any current CPU
> will do fine as long as they are in separate 128-byte chunks, but they
> need at least that much separation.
P4 manual says that if one processor modifies data within 2k of another
processor executing code, it will trash the entire trace cache.

    J
