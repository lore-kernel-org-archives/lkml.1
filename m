Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXDLVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXDLVJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXDLVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:09:52 -0400
Received: from 1wt.eu ([62.212.114.60]:1774 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXDLVJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:09:51 -0400
Date: Thu, 12 Apr 2007 23:09:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
Cc: Pedro <linux_user@izecksohn.com>, linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070412210944.GK943@1wt.eu>
References: <20070412203153.GJ943@1wt.eu> <AD98412A5373CC4AA643D9C021922A541C4DE0@cdskitexg01.cds.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AD98412A5373CC4AA643D9C021922A541C4DE0@cdskitexg01.cds.int>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 04:56:24PM -0400, Mouawad, Tony wrote:
> I have noticed that with overcommit_memory=2 and overcommit_ratio=100,
> my system cannot leverage as much ram as it could if it was configured
> for overcommit_memory=0.
> 
> Is this because when overcommit_memory=2, anything that mallocs memory
> but doesn't touch that memory is counted as used memory?

Most probably, yes. This proves that your system may endup doing OOM
in mode 0 if one of your applications suddenly decided to use all the
memory it has allocated.

> I see a value
> in /proc/meminfo called Commited_AS: and it seems to reflect what has
> been malloced in the system but not necessarily touched.  Is this true?

Yes (at least I do think so).

Regards,
Willy

