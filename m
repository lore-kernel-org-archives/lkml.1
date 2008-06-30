Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYF3Xd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYF3Xd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYF3XdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:33:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48331 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYF3XdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:33:18 -0400
Date: Tue, 1 Jul 2008 01:45:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Glauber Costa <gcosta@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: Re: [PATCH 17/39] clobber rbx in putuser_64.S
Message-ID: <20080630234504.GA3029@one.firstfloor.org>
References: <1214602486-17080-11-git-send-email-gcosta@redhat.com> <1214602486-17080-12-git-send-email-gcosta@redhat.com> <1214602486-17080-13-git-send-email-gcosta@redhat.com> <1214602486-17080-14-git-send-email-gcosta@redhat.com> <1214602486-17080-15-git-send-email-gcosta@redhat.com> <1214602486-17080-16-git-send-email-gcosta@redhat.com> <1214602486-17080-17-git-send-email-gcosta@redhat.com> <1214602486-17080-18-git-send-email-gcosta@redhat.com> <87abh5pxl6.fsf@basil.nowhere.org> <4869497B.5040100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4869497B.5040100@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But for this case, I think we can come up with a macro that selects the 
> appropriate register for each of them. Should be easy to do now that the 
> code is merged.

Note that each get_user() backend is ~10 lines or so. If you add
that many macros you might end up with more code than if you 
just keep them separate.

While I admit I am also partly to blame for some asm macro
mess, e.g. in entry.S, I relented and would now advocate
to minimize macro use in assembler. It simply makes it much
harder to understand and to change.

-Andi

