Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYJCRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYJCRol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYJCRoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:44:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34120 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYJCRoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=r2d3z6PkKLi0B4OAAwVE1bwQsFBSUQ3VQe5/rdqDD0V3m9OKcX6j6D1WhLIRP20gL2
         QX7PAFhLQxiVyhwjScaJxiZz+cSvKCfo+JZWftUC1VO1IfgYMJ1MLlHaeC6pu4MZF3wu
         Z9LgROjm+XPYtx4yNkNfwFy9JakdscOQkGIpU=
Message-ID: <48E659CB.5030902@tuffmail.co.uk>
Date: Fri, 03 Oct 2008 18:43:39 +0100
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
References: <48E62089.7050006@gmail.com>
In-Reply-To: <48E62089.7050006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> At this time, only built-in initcalls interest us.
> We can't really produce a relevant graph if we include
> the modules initcall too.
> 
> I had good results after this patch (see svg in attachment).

Sorry to butt in.  I think tracing module initcalls was a deliberate addition by Arjan (a06e1c2b448b317bc141934879cbbbed8319b4d4).

Maybe you use an initrd and that affects the trace?  It would be nice to see the "before" svg as well as the "after", to explain the change.

Thanks
Alan


