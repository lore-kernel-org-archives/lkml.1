Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZB0Akv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZB0Akv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZB0Akk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:40:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZB0Akj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:40:39 -0500
Message-ID: <49A73696.9020805@cn.fujitsu.com>
Date: Fri, 27 Feb 2009 08:40:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
 	file
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>	 <20090226130005.3282cb02.akpm@linux-foundation.org> <6599ad830902261628k4ce8e1aflb7981672562801fb@mail.gmail.com>
In-Reply-To: <6599ad830902261628k4ce8e1aflb7981672562801fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I don't see why we can't figure out the mode automatically based
> on whether or not there's a write handler defined for the control
> file.
> 

This almost works.. except for 'tasks' file, which has no 'read' handler
but is readable.

