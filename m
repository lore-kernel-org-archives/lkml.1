Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYIHQrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYIHQrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIHQrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:47:13 -0400
Received: from gw.goop.org ([64.81.55.164]:41341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYIHQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:47:12 -0400
Message-ID: <48C5570B.7050109@goop.org>
Date: Mon, 08 Sep 2008 09:47:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
References: <patchbomb.1220777491@localhost> <48C3F237.1020503@tuffmail.co.uk> <200809082123.04780.nickpiggin@yahoo.com.au>
In-Reply-To: <200809082123.04780.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Why not high memory as well? We put page tables there too...
>   

Well, the specific problem is that the BIOS appears to corrupt low
memory.  It might corrupt other memory anywhere, but that would be
pretty pathologically evil.  The assumption is that it gets away with it
because its memory that Windows doesn't otherwise use or something.

> (rant: why can we still buy non-ECC memory?)
>   

Well, it wouldn't help in this case.  It's not random hardware bit-flipping.

    J
