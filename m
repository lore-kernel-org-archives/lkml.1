Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZIRTme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZIRTme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZIRTm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:42:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbZIRTm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:42:27 -0400
Date: Fri, 18 Sep 2009 12:41:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
  Re: [PATCH] Remove broken by design and by implementation devtmpfs 
 maintenance disaster)
In-Reply-To: <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909181239120.4950@localhost.localdomain>
References: <20090917125759.GA4045@kroah.com> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>  <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>  <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> 
 <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>  <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com>  <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>  <20090918150541.GB9307@kroah.com>
 <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com> <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Kay Sievers wrote:
> 
> With that patch, I can login as a normal user without any udev ever
> started, and no static content copied to /dev.

I think this is something to aim for as a goal. 

No, it may not be a /dev you'd want to use normally, but from a robustness 
and stability angle, having a policy that says "we should aim to _work_ 
even without udev running at all, even if you don't get the frills". So at 
that point devtmpfs actually offers users something.

			Linus
