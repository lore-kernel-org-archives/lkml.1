Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0CHXT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHXTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:19:24 -0500
Message-ID: <4B9585BD.6070904@redhat.com>
Date: Mon, 08 Mar 2010 18:18:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 01:08 PM, Linus Torvalds wrote:

> Things like "/etc/passwd" really are about the _pathname_, not the inode.
> It really is the _path_ that is special, because that is fundamentally the
> thing you trust.

On the other hand, '/etc/shadow' has the opposite constraint,
where the system will not trust most of the applications with
the data from that file.

Using label security to protect the contents makes sense there.

Your example appears to be about "can the application trust
the data?", while the label based security solves "can the
application be trusted with the data?"

These are two different things.
