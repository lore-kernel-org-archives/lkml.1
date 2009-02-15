Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZBOT0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZBOT0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZBOT0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:26:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52697 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZBOT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:26:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49986C31.90800@s5r6.in-berlin.de>
Date: Sun, 15 Feb 2009 20:25:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Junio C Hamano <junio@pobox.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
References: <1234451714.10603.22.camel@laptop>	 <20090212192104.GD15809@csclub.uwaterloo.ca>	 <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de>	 <20090213163923.GE15809@csclub.uwaterloo.ca>	 <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org>	 <49984ED4.4000306@s5r6.in-berlin.de> <1234722605.4713.192.camel@laptop>
In-Reply-To: <1234722605.4713.192.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2009-02-15 at 18:20 +0100, Stefan Richter wrote:
>> from the manual:
>>
>>        --chain-reply-to, --no-chain-reply-to
>>            [...] Default is the value of the sendemail.chainreplyto
>>            configuration value; if that is unspecified, default to
>>            --chain-reply-to.
>>
>> Everybody who isn't afraid of configuration files can implement his
>> preferred default easily.
> 
> Yep, trouble is with all those folks who
> 
>  1) don't know about the option
>  2) aren't educated to know its a good idea to use it
> 
> So by changing the default we're better off all around.

There will always be trouble with these folks. ;-)

Two more thoughts:  Since git-send-email puts sequence information into
the Subject header, additional sequence info in the References header is
redundant.  It is sufficient that the References or In-Reply-To header
carries information about which mail thread a posting belongs to.

On the other hand, --no-chain-reply-to makes less sense if the thread
starts with a 1/n posting instead of an introductory 0/n one.

(What if git-send-email could optionally generate a 0/n posting with
shortlog and combined diffstat as default content?)
-- 
Stefan Richter
-=====-==--= --=- -====
http://arcgraph.de/sr/
