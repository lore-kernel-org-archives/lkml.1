Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYBTS1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYBTS1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYBTS1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:27:38 -0500
Received: from ag-out-0708.google.com ([72.14.246.244]:48310 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYBTS1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PifrvCbNa6t1CtTxb3/j9SNbEK5VcqpTdh5zBTFmBTsS1N2JowqO1YlutwtdGG8Gl5ju7YrTuEC+MtSoPurKlPgIO8uc0qRn5g0Axtrtqj0mdWRMBTR3UWVC8EokEO3HiP6WagT5HxvSIrCdDJM9sXpiShD7do47A4mdtGGN7sw=
Message-ID: <47BC7101.4060501@gmail.com>
Date: Wed, 20 Feb 2008 13:27:13 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
References: <Pine.LNX.4.44L0.0802201213260.5630-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201213260.5630-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/2008 12:15 PM, Alan Stern wrote:

> On Wed, 20 Feb 2008, Andrew Buehler wrote:

>> Hmm. One thing which just sprang to mind, in the stab-in-the-dark
>> category: in 2.6.24.2, launching the program on some machines gave
>> warnings along the lines of "this program is using a deprecated
>> ioctl, please convert it to SG_IO" (which I naturally cannot do
>> since it's closed and I don't have the source),
> 
> You can ask the program's author to update it.

It's provided by Novell, with whom I have no direct contact and am not
presently authorized to speak on behalf of my organization. From what I
have read about the history of their support on this program and these
discs, I do not expect that they would be willing to support it except
in environments which they provide in monolithic form; it would be
possible for me to copy an updated version of the program out of such an
environment to use in my own customized one, but I am not certain that
they have even created such an updated version, and in any case
obtaining it would almost certainly require buying the latest version of
Novell ZENworks - which my organization is certainly not prepared to do
at the present time.

In other words: I don't think that's likely to be practical in the
present instance. If you have reason to believe otherwise (past positive
experience with Novell, for instance), I'd be glad to hear it.

>> I'm not sure I expressed myself clearly. I do not think the problem
>> is with the different kernels. I think the problem is with the
>> different configurations. I am asking if there are any established
>> techniques for comparing differences between config files from
>> widely different kernels.
> 
> Not as far as I know.

Oh, well... thanks anyway.

Is there any place (aside from maybe the kernel changelog, which
contains a whole lot - if not several lots - of unrelated information)
where I could find a list of config-symbol name additions, changes,
deletions and meaning changes by version or by date? That would at least
let me build a mapping between the symbols in the older config and the
ones in the new one, which is about where I would have to start.

-- 
    Andrew Buehler
