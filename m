Return-Path: <linux-kernel-owner+w=401wt.eu-S1764940AbXFAUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764940AbXFAUwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762980AbXFAUw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:52:26 -0400
Received: from homer.mvista.com ([63.81.120.155]:52504 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763542AbXFAUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:52:25 -0400
Message-ID: <46608764.5060807@ru.mvista.com>
Date: Sat, 02 Jun 2007 00:53:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Geller Sandor <wildy@petra.hos.u-szeged.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: HPT374 IDE problem with 2.6.21.* kernels
References: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu> <20070601134607.ce4a37bd.akpm@linux-foundation.org>
In-Reply-To: <20070601134607.ce4a37bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:

>>I saw a similar report yesterday with '2.6.21.1 - 97% wait time on IDE 
>>operations' subject.

>>After upgrading from 2.6.20.7 kernel to 2.6.21.1 my system started to 
>>reset infrequenly the IDE bus. In the syslog DMA timeout, resetting IDE 
>>bus messages appeared. I've changed the two disks attached to the HPT374 
>>controller, and always the first disk had problems. I've replaced cables, 
>>plugged the disks into other IDE ports, but it was only a matter of time 
>>to experience an IDE reset. When I upgraded to 2.6.21.3 the resets became 
>>much more frequent, this time even DMA was disabled too on the first disk. 
>>I turned DMA back Manually with hdparm, and a few seconds of intense IO 
>>activity resulted in another IDE reset.

>>Reverting back to 2.6.20.12 the problem seems to be gone. BTW I'm using 
>>the PATA driver for the HTP374, not the libata one.

>>Is this a known problem/ is there a way I can help locating the cause of 
>>the problem?

    Yes, please post the boot log and the IDE reset log too for starters...

> (cc's added)

WBR, Sergei
