Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYAMV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYAMV3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYAMV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:29:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:13040 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbYAMV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TBT5rWif4ovPPQbegCMmwI6RjcBxxomvJNy+pb3byNoI7znYHKoXA6l9RK93a+D7bcH4HEK9XwBuQIdMW5zLZH7CUJ9gUojhQ2l/FnoMAZOJTSYU6xmtpWAQCKGrGs5l384ItSW7SwVgzD+KUfpOqrXOzU3LZ1r3sZy4x5m7bT8=
Message-ID: <478A82AD.3070904@gmail.com>
Date: Sun, 13 Jan 2008 22:29:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com>
In-Reply-To: <478A8131.9050500@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2008 10:22 PM, Jiri Slaby wrote:
> This routine seems to be re-entrant due to parameters on stack + the 
> spin lock, hence the lock is not needed here at all.

s/parameters/variables/; too sleeeepy.
