Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYGOBzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYGOBzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYGOByy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:54:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48184 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYGOByy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:54:54 -0400
Message-ID: <487C0365.5030203@garzik.org>
Date: Mon, 14 Jul 2008 21:54:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>	<20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org>
In-Reply-To: <20080714165956.7fe2d4ee@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 14 Jul 2008 16:41:19 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Mon, 14 Jul 2008 16:23:26 -0700
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>
>>> Linus, please pull from the for-2.6.27 branch of:
>>> 	git://git.infradead.org/users/dwmw2/firmware-2.6.git
>>> for-2.6.27
>> The firmware flamewars seem to have subsided lately.  Is everyone
>> happy with this now?
>>
> 
> this seems to have left the contentious pieces out....

Correction:  It seems to have completely ignored contentious issues, 
which is not the same thing.

It -removes- the ability to build firmware into the kernel module -- a 
currently deployed, highly reliable configuration.

I'm not surprised that fact was snipped in David's submission -- 
wouldn't want to mention that you are unconditionally replacing a 
reliable method of firmware loading with a less reliable one.

Building the firmware into the kernel is far less useful than it 
appears:  often users lack the ability to maintain their own vmlinuz 
kernel image build, but do build updated drivers.  e.g. driver disks for 
Red Hat Enterprise Linux.

IMO the newly added /inability/ to build firmware into kernel modules is 
a clear regression.

	Jeff




