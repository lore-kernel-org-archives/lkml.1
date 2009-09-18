Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZIRWHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZIRWHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZIRWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbZIRWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:07:16 -0400
Date: Fri, 18 Sep 2009 15:06:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
In-Reply-To: <ac3eb2510909181419p4a9fa382pc93c81aaa871e80c@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909181506150.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <m1ab0tcwep.fsf@fess.ebiederm.org>  <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>  <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> 
 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>  <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>  <1253238637.4071.10.camel@yio.site> <m14or0vul4.fsf@fess.ebiederm.org>  <alpine.LFD.2.01.0909181407370.4950@localhost.localdomain>
 <ac3eb2510909181419p4a9fa382pc93c81aaa871e80c@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Kay Sievers wrote:
>
> > Yeah, I think that's the way to go.
> 
> Are we sure about console? It's not what udev does today, it stays as 0600.

You're right, I didn't notice /dev/console there. That's wrong. Very 
different from /dev/tty.

		Linus
