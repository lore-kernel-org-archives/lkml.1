Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXIFJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXIFJbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 05:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXIFJbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 05:31:10 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:48274 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754831AbXIFJbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 05:31:09 -0400
Message-ID: <46DFC8D7.9020708@moving-picture.com>
Date: Thu, 06 Sep 2007 10:31:03 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com> <200605242029.k4OKTn9C031700@terminus.zytor.com> <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com> <46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com> <h87in5sgal.fsf@pepelac.englab.brq.redhat.com> <46DE6196.3050605@zytor.com> <46DEE0C9.1000402@moving-picture.com> <20070905172252.GA2104@martell.zuzino.mipt.ru>
In-Reply-To: <20070905172252.GA2104@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Wed, Sep 05, 2007 at 06:00:57PM +0100, James Pearson wrote:
> 
>>H. Peter Anvin wrote:
>>
>>>Anton Arapov wrote:
>>>
>>>
>>>> Hey guys, the future of this patch is important for me. What do you 
>>>>think, has this patch any chances to be committed to upstream?
>>>>
>>>>James Pearson <james-p@moving-picture.com> writes:
>>>>
>>>>
>>>>>H. Peter Anvin wrote:
>>>>>There isn't that much that is duplicated - and there are also bits of
>>>>>the /proc/PID/mem code that are not needed in this case, so I'm not
>>>>>really sure if it is worth doing.
>>>>>
>>>>>I did submit a patch a few months ago - see:
>>>>>
>>>>><http://marc.info/?l=linux-kernel&m=117862109623007&w=2>
>>>>
>>>>
>>>Looks reasonable to me, except for the one overlong line.
>>>
>>
>>OK, here is the patch (without the long line) against 2.6.23-rc5 - what 
>>else needs to be done to get it committed?
> 
> 
> Remove duplicate ptrace_may_attach() checks, unecessary (), {} and
> spaces before pointer names -- char *buf.

environ_read() in the patch uses ptrace_may_attach() in a similar way as 
does mem_read(). Given that environ_read() is based on mem_read(), does 
this mean that duplicate ptrace_may_attach() checks need to be removed 
from mem_read() as well? Which ptrace_may_attach() needs to be removed?

Thanks

James Pearson
