Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0CHXxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:53:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab0CHXxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:53:04 -0500
Message-ID: <4B958D7F.1030900@redhat.com>
Date: Mon, 08 Mar 2010 18:51:27 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com> <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 06:37 PM, Linus Torvalds wrote:

> That's an example of non-pathname-based security, where you actually mark
> the content itself restricted some way. It's very naturally done with
> labels on the inode itself. It's what UNIX has _always_ done
>
> Nobody has ever suggested removing that. That would be crazy.

It is quite clear that the content based security
protects the content from being manipulated by
processes that should not be able to do so.

However, what is unclear to me is ...

> But that thing is _independent_ from the other totally unrelated issue,
> namely the fact that "/etc/passwd" is a special name in the namespace. In
> other words, there is "content security", but then there is also
> "namespace security".

... what exactly does the namespace security protect against?

What is the threat model that the namespace security protects
against, which is not protected by the content based security?

