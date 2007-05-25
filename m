Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbXEYXn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbXEYXn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXEYXnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:43:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXEYXnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:43:50 -0400
Message-ID: <465774AD.8020408@zytor.com>
Date: Fri, 25 May 2007 16:43:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ben Collins <ben.collins@ubuntu.com>, Andi Kleen <andi@firstfloor.org>,
       Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from compressed
 boot wrapper
References: <98cd38b5.git.bcollins@ubuntu.com> <200705251623.55551.jbarnes@virtuousgeek.org> <46577112.7090106@zytor.com> <200705251638.37489.jbarnes@virtuousgeek.org>
In-Reply-To: <200705251638.37489.jbarnes@virtuousgeek.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> 
> Right, but you're special that way.  And moreover, you would know how to add 
> such debug statements as needed.  But is this output something we really need 
> enabled unconditionally for everyone?
> 

*I* can do that, yes, but I usually don't have access to the platform in
question.

As such I really don't want to see this as a compilation option.  Make
it a runtime option[*] so the user with the problematic machine.

> I personally don't care that much, aside from the feeling that we have way too 
> many printks in general...

[*] FWIW, my setup rewrite has a proper command-line parser in it, so we
can use the command line from the start.
