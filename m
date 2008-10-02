Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYJBPfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYJBPfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYJBPfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:35:00 -0400
Received: from gw.goop.org ([64.81.55.164]:43239 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYJBPe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:34:59 -0400
Message-ID: <48E4EA1C.2090808@goop.org>
Date: Thu, 02 Oct 2008 08:34:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] xen: nuke the ballon files
References: <20081002150529.087488257@goodmis.org> <20081002151105.025170721@goodmis.org>
In-Reply-To: <20081002151105.025170721@goodmis.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Investigating the unused static files in the balloon code, I discovered
> that the balloon code is not used at all.
>
> The header file is one big #if 0 and all the functions in the C file
> is static. There is no caller like init_module to hook to any of
> these functions. Basically, this code is one big patch of dead code
> wasting space on my hard drive.
>
> This patch removes the balloon code altogether since there are no
> users.
>   

Er, I think you should back away from that crack pipe.

> -subsys_initcall(balloon_init);

    J
