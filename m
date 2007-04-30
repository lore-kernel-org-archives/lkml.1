Return-Path: <linux-kernel-owner+w=401wt.eu-S1031575AbXD3T4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031575AbXD3T4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031584AbXD3T4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:56:11 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54835 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031575AbXD3T4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:56:10 -0400
Message-ID: <463649D5.9000406@simon.arlott.org.uk>
Date: Mon, 30 Apr 2007 20:56:05 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: Revert "[POWERPC] <various>"
References: <46362B14.6090106@simon.arlott.org.uk> <20070430194911.GA1156@aepfle.de>
In-Reply-To: <20070430194911.GA1156@aepfle.de>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/07 20:49, Olaf Hering wrote:
> On Mon, Apr 30, Simon Arlott wrote:
> 
>> There are a few powerpc patches plus reverts in the recent push to 
>> torvalds/linux-2.6 - shouldn't this be avoided whenever possible because it 
>> could cause problems for people trying to use git bisect?
> 
> The reverts do not cause compile failures (I hope).
> You may lose IDE if you happen to debug something on Pegasos.
> I'm sure the real bisect breakers are elsewhere.

The reverts themselves are not the real problem, a git bisect could occur 
between the commit adding it and the one that reverts it. If that commit 
introduced a bug then surely it would be better to avoid releasing it 
elsewhere even if it will be reverted in the same batch.

Of course, this is probably difficult to do with git and impossible if 
someone has cloned the bad commit already and tries to pull :/

Is it possible to mass copy all the good commits to create a clean branch?

-- 
Simon Arlott
