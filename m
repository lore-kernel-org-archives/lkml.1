Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYKBWWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYKBWWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYKBWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:22:00 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:46580 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbYKBWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:21:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=j47qcu8PzirL91ZGri8Txx9okjptbD0rN2XD2F8kV2HjXClTGoWQZTUGOGjIwBMi5ZBEXzZfbbZjL/XQS4aFhbsquXe7Bv937VbyNM8Fq64aI+JK4AzXbuNF0Z3Fw6cx;
Message-ID: <490E2800.2000205@simon.arlott.org.uk>
Date: Sun, 02 Nov 2008 22:21:52 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: "Michael B. Trausch" <mike@trausch.us>
CC: linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Thomas Meyer <thomas@m3y3r.de>, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [Bug 11910] AMD64 reboot regression
References: <20081102153009.6b1f2ab4@zest>
In-Reply-To: <20081102153009.6b1f2ab4@zest>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/08 20:30, Michael B. Trausch wrote:
> I started testing 2.6.28 with -rc1 on my system (x86-64, AMD Phenom
> 9500 Quad Core CPU) and found that I was unable to reboot, though I was
> able to with the Ubuntu-provided 2.6.27 kernel.  I have found that a
> commit on 17-Oct-2008 (commit 8fd145917fb62368a9b80db59562c20576238f5a)
> is responsible for this failure to reboot.  Reversing this single change
> on my local kernel (current git tree plus this patch) has enabled me to
> reboot again.
> 
> System board information is attached in the hopes that it will be found
> helpful; if any other information is necessary please let me know.
> 
> The patch that reverts this change is attached, with stat:
> 
>  drivers/acpi/reboot.c |   25 +++----------------------
>  1 files changed, 3 insertions(+), 22 deletions(-)

I'm having the same problem and reverting this commit fixes it too.

-- 
Simon Arlott

