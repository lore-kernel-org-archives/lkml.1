Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbZBXUwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbZBXUwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZBXUwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:52:38 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1945 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074AbZBXUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:52:37 -0500
Message-ID: <49A45E13.80608@cybernetics.com>
Date: Tue, 24 Feb 2009 15:52:35 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
References: <49A42DDE.8060605@cybernetics.com> <49A4387D.2020801@cosmosbay.com> <49A43FF0.2070703@cybernetics.com> <49A44FEB.6000803@cosmosbay.com> <49A45A48.6020805@cybernetics.com> <alpine.DEB.2.00.0902241241530.20039@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0902241241530.20039@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> No. Like it has been explained, MT applications can report events for 
> closed files anyway. It is a matter of where the close() happen in time 
> (pretty easy to figure out if you make a time/thread chart).
> As for the other patches, some could be applied, but I didn't look at them 
> deeply and I need time to review them. Will take time to review them 
> tomorrow or the day after.
>
>
>
> - Davide
>
>
>
>   

OK then.  Not the answer I wanted, but that's life.  Good news for
everyone else though - there is no need to remake the patches already in
-mm.  So please ignore the patches marked [2.6.29] and use the patches
marked [-mm] instead (excluding patch #1, which has now been rejected).

Tony

