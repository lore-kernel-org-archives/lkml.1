Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbXEPJNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbXEPJNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEPJMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:12:50 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31608 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756058AbXEPJMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:12:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=m6c7GOrf1QAle1NMU6ZzDyXW21nWA/QJWp/nExrsiwmZF+FSJZPkDnIksrO3mVgSuHBmiwht4iDpbYI5p671wrFlBKPbbZYp5/bktTzhyoJsfWFq5i1MMQ01RGWapZjqH9HccrpwCoVswxDmOYiPIf0qSkHJLE/pr4N/U058+wQ=  ;
X-YMail-OSG: B746yUYVM1kuj_0bejGHj1kPhW9SiGolKj_HNf1Ph5M7aULIJr5isiE6Sws7UtHGL9wUJsSHuA--
Message-ID: <464ACB0B.7040603@yahoo.com.au>
Date: Wed, 16 May 2007 19:12:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.21.1] OOPS in timer stats code
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl>	 <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com>	 <4649FDEA.2050703@redhat.com> <1179267292.12838.42.camel@chaos>
In-Reply-To: <1179267292.12838.42.camel@chaos>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> Dammit. It's a HT enabled box again. I don't have one.
> 
> Folkert, does the problem go away when you disable HT
> (CONFIG_SCHED_SMT) ?

Why would that make a difference? If you do suspect it is the problem,
then I think you could just do something like substitute cpu_online_map
for the sibling map in the SMT domain setup in order to reproduce it
locally?

-- 
SUSE Labs, Novell Inc.
