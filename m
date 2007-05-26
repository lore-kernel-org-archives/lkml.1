Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXEZDMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXEZDMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 23:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXEZDMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 23:12:09 -0400
Received: from smtpout.mac.com ([17.250.248.174]:59875 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXEZDMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 23:12:08 -0400
In-Reply-To: <20070526022342.GA20905@fieldses.org>
References: <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <20070526022342.GA20905@fieldses.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A02B7736-39AA-4B50-B682-756C387AEDEC@mac.com>
Cc: David Howells <dhowells@redhat.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] AFS: Implement file locking
Date: Fri, 25 May 2007 23:11:33 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25, 2007, at 22:23:42, J. Bruce Fields wrote:
> On Thu, May 24, 2007 at 05:55:54PM +0100, David Howells wrote:
>> +	/* only whole-file locks are supported */
>> +	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
>> +		return -EINVAL;
>
> Do you allow upgrades and downgrades?  (Just curious.)

I was actually under the impression that OpenAFS had support for byte- 
range locking (as well as lock upgrade/downgrade); though IIRC there  
was some secondary protocol.  That's probably why the support is so  
basic at the moment; David's getting the basics in first and the more  
complicated stuff can come later.

Cheers,
Kyle Moffett

