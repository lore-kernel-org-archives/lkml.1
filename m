Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZJUVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZJUVTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJUVTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:19:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34737 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZJUVTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:19:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ADF7AED.2030506@s5r6.in-berlin.de>
Date: Wed, 21 Oct 2009 23:19:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091017 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] Disk hot removal causing oopses and fixes
References: <20091021161201.GA16968@angel.research.nokia.com> <4ADF752D.7010206@s5r6.in-berlin.de>
In-Reply-To: <4ADF752D.7010206@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I dare say without knowing the MMC and block system:  It is not a
> locking issue, it is a reference counting issue.
[...]
> The whole secret is not to forget to count _all_ references.

PS, in case that it might be needed:  Sometimes a low level wants to
wait for the moment until its upper level users went away.  Reference
counting is then coupled with constructs like wait_for_completion then.
-- 
Stefan Richter
-=====-==--= =-=- =-=-=
http://arcgraph.de/sr/
