Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYKGIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYKGIAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYKGIAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:00:22 -0500
Received: from hope.ime.usp.br ([143.107.45.8]:56746 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750929AbYKGIAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:00:20 -0500
Message-ID: <1226044855.4913f5b7f2f45@webmail.ime.usp.br>
Date: Fri, 07 Nov 2008 06:00:55 -0200
From: Rogerio Theodoro de Brito <rbrito@ime.usp.br>
To: =?iso-8859-1?b?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br>
In-Reply-To: <20081107014535.GA19201@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.1
X-Originating-IP: 189.39.150.164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Some more information that may prove to be useful.

Quoting Rogério Brito <rbrito@ime.usp.br>:
> If any further information is needed, please let me know.

I just discovered that the "suspend button" is overloaded: it is actually 
a poweroff button, which would explain the behaviour when the kernel is in 
suspend to RAM.

(This notebook doesn't have a suspend hehaviour when closing the lid, as 
far as I could observe right now).

I just reinstalled Windows Vista (from the rescue DVD) and it suspends and 
resumes fine. I don't know where Windows stores its logs (sorry, I've been 
using Unix systems for more than a decade).

So, summarizing, it seems that the "suspend to RAM" button is actually a 
poweroff button, but this behaviour of powering off the machine manifests 
only when the kernel is already in a suspend to ram state. I can provide 
more information under guidance. Please, just let me know what is needed 
and I will test anything, as this notebook has not yet been used for 
production.


Thanks in advance for any help, Rogério Brito.

-- 
Rogério Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
