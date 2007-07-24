Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbXGXLTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbXGXLTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761125AbXGXLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:19:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3746 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146AbXGXLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:19:25 -0400
Message-ID: <46A5E034.2030205@shadowen.org>
Date: Tue, 24 Jul 2007 12:19:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>	<46A534EA.6030008@intel.com>	<46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org>
In-Reply-To: <20070724021526.3d92286b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 24 Jul 2007 10:06:51 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
>>> This is a royal pain, since it now throws an ERROR for the obviously
>>> preferable piece of code below:
>>>
>>> if (err) {
>>>     do_something();
>>>     return -ERR;
>>> } else {
>>>     do_somthing_else();
>>> }
>> Hmmm, is that obviouly nicer than the below?  Its fully a line longer
>> for no benefit.  But ignoring that, this seems to have snuck in to
>> CodingStyle hmmm ... will see what I can do if anything to stop these
>> being picked up I guess.
>>
>> 	if (err) {
>> 		do_something();
>> 		return -ERR;
>> 	} else
>> 		do_something_else();
> 
> The kool kids on linux-usb-devel largely ended up deciding that the second
> version looks dorky.
> 
> Especially if there's a comment over do_something_else(), and if there's
> not a comment, perhaps there should be?
> 
>> Andrew, as you merged the change to CodingStyle I'll take that as your
>> being ok with these being accepted.
> 
> It's very marginal and is sure to get people hot and bothered.  I'd suggest
> that checkpatch be neutral on that.

Ok, now if either the preceeding block or following block has {}'s then
we don't report this block for being one line long.  We will miss some
this way, but hey.

-apw
