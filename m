Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbXIYOHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbXIYOHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXIYOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:07:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:26566 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXIYOHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=e5Qd3g76zDH+r3aweQZD6TtrRVi3gWmA7lp3yNEuO34GwMG4XTsmgcP/TOVwJlF8hKwdT0ZPlAQ3lQbVFne2PT0UY3kfoB6o8QwT1EH4dSzTcDYbK9Y8FATNroqt6i7Rs4dkjjaSwJi8HyCxHVFeY8aVf9yEW+V7wN0QP9tETxU=
Message-ID: <46F915AC.4030301@gmail.com>
Date: Tue, 25 Sep 2007 23:05:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>	 <1190677332.27805.229.camel@localhost.localdomain>	 <46F86727.4050004@gmail.com>	 <1190686320.27805.258.camel@localhost.localdomain>	 <46F874DB.5070205@gmail.com>	 <1190690493.27805.263.camel@localhost.localdomain>	 <46F8822D.2010003@gmail.com>	 <1190695118.27805.307.camel@localhost.localdomain>	 <46F8C5ED.6060101@gmail.com>  <46F8C8AA.3030803@gmail.com> <1190710249.27805.326.camel@localhost.localdomain>
In-Reply-To: <1190710249.27805.326.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-09-25 at 17:36 +0900, Tejun Heo wrote:
>> Hmmm.... There doesn't seem to any reason why the blocking should be
>> after calling ->exit().  And, yeah, it would be more useful and
>> intuitive if blocking happens before ->exit().  What do you think?
> 
> *That* I have no problem with.
> 
> I was going to say "just grab a reference to every module" except if a
> new module is loaded you don't know about it.
> 
> If you move your blocking, it seems fine.

Great, I think I was too occupied with the sysfs case when I was writing
it.  I'll update the patch.  Thanks a lot.

-- 
tejun
