Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0CJKHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:07:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58239 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0CJKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:07:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=srSYvXLMUF3jlvB+j5vBW+zjjd+uazQUxZA65K9Sveb1WS7k9qaWJbweJCfWREcVZ
	Zc2D9JaoooA1JMl8ai1WA==
Date: Wed, 10 Mar 2010 02:07:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
cc: Jakub Narebski <jnareb@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johannes Sixt <j.sixt@viscovery.net>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
In-Reply-To: <4B9120F2.2020000@gmail.com>
Message-ID: <alpine.DEB.2.00.1003100205170.17698@chino.kir.corp.google.com>
References: <4B90CBE5.9090102@viscovery.net> <1267780845-10547-1-git-send-email-jslaby@suse.cz> <m3pr3jkq26.fsf@localhost.localdomain> <4B9120F2.2020000@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Jiri Slaby wrote:

> On 03/05/2010 11:43 AM, Jakub Narebski wrote:
> >> +!/.gitignore
> >> +!/.mailmap
> > 
> > Actually you want to *not ignore* .gitignore and .mailmap (and
> > .gitattributes which is missing here) anywhere, not only as top-level
> > file.  So .gitignore and .mailmap should not be prepended with slash.
> 
> <and moved out of the 'Top-level generic files' section then>
> 

Please either revert 3b2a8c8f3c65 or merge the fixed up patch for 
2.6.34-rc2, otherwise include/linux will continue to be ignored by git 
just like it is for 2.6.34-rc1.
