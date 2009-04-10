Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbZDJCcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbZDJCcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbZDJCcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:32:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:39386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZDJCcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CLdsfOF6+9VlOsAwoy7kQ24iIn5DDb7nnchn6OwBa5gSbC3lCCyvcIoUntEsRuVf51
         KQURCW+PP/rTEQ0JOUsblHCH2vaPQ+yJxkX93TVT7zVbSQxYfi37G+sTfttCDjTgyRA6
         UJF+xcv8Ol0mpRXMHmz6DSoEajRs4oysKIl7E=
Date: Fri, 10 Apr 2009 06:32:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090410023207.GA27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to show how we see C/R and to provoke discussion on number of
important issues (mounts, ...).

This is small part of long-awaited to be cleanuped code.

It's able to restore busyloop on i386 and x86_64 and restore i386
busyloop on x86_64. It wasn't tested much more than that.

I'm currently starting formal testsuite, otherwise it's whack-a-mole
game and formal TODO list (a huge one).
