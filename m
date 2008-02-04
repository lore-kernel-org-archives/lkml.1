Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYBDV5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYBDV5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYBDV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:57:40 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41329 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYBDV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:57:39 -0500
Date: Mon, 4 Feb 2008 21:56:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yi Yang <yi.y.yang@intel.com>, Greg KH <greg@kroah.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1: module params broken
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802042140250.8210@blonde.site>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please chuck out:
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
(along with Randy's perfectly reasonable -fix.patch).

So predictable that it would just disable loading modules with params:
Feb  4 13:17:02 blonde kernel: thinkpad_acpi: `1' invalid for parameter `experimental'

Maybe it's something as simple as a trailing whitespace issue,
I haven't looked, would prefer the originator to do so.
openSUSE 10.3 if that makes any difference.

Hugh
