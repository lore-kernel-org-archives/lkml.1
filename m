Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZCGTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZCGTGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZCGTFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:05:55 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58949 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCGTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:05:54 -0500
Date: Sat, 7 Mar 2009 11:04:28 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       roland@redhat.com, Greg Kurz <gkurz@fr.ibm.com>
Subject: Re: [PATCH 0/7][v8] Container-init signal semantics
Message-ID: <20090307190428.GA30594@us.ibm.com>
References: <20090219030207.GA18783@us.ibm.com> <499D73C8.3090209@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499D73C8.3090209@free.fr>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Gregory Kurz proposed a solution:
>    * when shutdown is called and we are not in the init pidns, then we kill 
> the process 1 of the pidnamespace.
>    * when reboot is called and we are not in the init pidns, then we reexec 
> the init process, using the same command line. I guess this one could be 
> easily retrieved if we are able to display /proc/1/cmdline ;)
>
> IMHO, this is a good proposition because it is generic and intuitive, no ?
>
> What do you thing ?

Yes, I think it makes sense. Do we have any prototype patches that
implement this behavior ?
