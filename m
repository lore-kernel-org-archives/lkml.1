Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZJ2QWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZJ2QWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZJ2QWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:22:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:39130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZJ2QWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:22:50 -0400
Message-ID: <4AE9C1A3.8090809@suse.de>
Date: Thu, 29 Oct 2009 17:24:03 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] Fix updating of named attribute groups
References: <20091020054740.GC29158@parisc-linux.org> <20091020054946.GD29158@parisc-linux.org> <4AE9BBC6.3070304@suse.de> <20091029161907.GL10555@parisc-linux.org>
In-Reply-To: <20091029161907.GL10555@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Matthew Wilcox wrote:
>>> +	} else {
>>> +		sd = sysfs_get(kobj->sd);
>>> +	}
>> nitpick: the last braces aren't necessary.
> 
> But are more aesthetically pleasing.

Hmmm... indeed, CodingStyle says

  Do not unnecessarily use braces where a single statement will do.

  if (condition)
	  action();

  This does not apply if one branch of a conditional statement is a single
  statement. Use braces in both branches.

  if (condition) {
	  do_this();
	  do_that();
  } else {
	  otherwise();
  }

So, please ignore my previous nitpick.

Thanks.

-- 
tejun
