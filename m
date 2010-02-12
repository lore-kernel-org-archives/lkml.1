Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0BLTE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:04:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab0BLTE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:27 -0500
Message-ID: <4B75A5FE.8020408@zytor.com>
Date: Fri, 12 Feb 2010 11:03:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare>
In-Reply-To: <20100212150137.648dca7c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 06:01 AM, Jean Delvare wrote:
> 1* Keep a single compression format. This saves almost 40% of the
> files.
> 
> 2* Move one of the compression formats somewhere else, so that it
> doesn't get in the way but is still available if needed.

Neither of these are feasible, sorry.

> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
> related files there. This would shrink the main index drastically, and
> each subdirectory would have a reasonable size (except maybe 2.6.16 and
> 2.6.27.) Oddly enough this has been done for the files under testing/
> already, so I am curious why we don't do it for the release files (and
> the testing/incr/ files, while we're at it.)

Well, part of the reason why is that we're functionally "stuck" on 2.6;
a prefix which really has lost all meaning.

It might open up the question if we shouldn't just do a Solaris and drop
the leading 2 (so the next kernel would be 6.33) or call the kernel
after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.

	-hpa
