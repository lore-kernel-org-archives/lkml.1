Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbXEUN6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbXEUN6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXEUN60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:58:26 -0400
Received: from as4.cineca.com ([130.186.84.213]:34216 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbXEUN6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:58:25 -0400
Message-ID: <4651A564.9090509@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <46517817.1080208@users.sourceforge.net> <20070521110406.GA14802@vanheusden.com> <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr> <20070521124734.GB14802@vanheusden.com>
In-Reply-To: <20070521124734.GB14802@vanheusden.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 15:58:25 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden wrote:
>>> What about the following enhancement: I check with sig_fatal if it would
>>> kill the process and only then emit a message. So when an application
>>> takes care itself of handling it nothing is printed.
>>> +	/* emit some logging for unhandled signals
>>> +	 */
>>> +	if (sig_fatal(t, sig))
>> Not unhandled_signal()?
> 
> Can we already use that one in send_signal? As the signal needs to be
> send first I think before we know if it was handled or not? sig_fatal
> checks if the handler is set to default - which is it is not taken care
> of.

What about ptrace()'d processes? I don't think we should log signals for them...

-Andrea
