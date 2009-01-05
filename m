Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZAEQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZAEQ2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZAEQ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:28:12 -0500
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:60166 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbZAEQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:28:11 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 11:28:10 EST
Message-ID: <49623384.2070801@aon.at>
Date: Mon, 05 Jan 2009 17:21:24 +0100
From: Peter Klotz <peter.klotz@aon.at>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de>
In-Reply-To: <20090105064838.GA5209@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> I believe this patch should solve it. Please test and confirm before
> I send it upstream.


My test successfully completed two times, writing a 900GB file in each run.
I used a patched 2.6.27.10 x86_64 kernel.

On an unpatched system this test usually fails before reaching 100GB.

Thank you for fixing this issue that quick.

Regards, Peter.
