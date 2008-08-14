Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYHNAU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYHNAU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHNAUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:20:11 -0400
Received: from main.gmane.org ([80.91.229.2]:36010 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYHNAUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:20:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com>
Subject: Re: TALPA - a threat model?  well sorta.
Date: Wed, 13 Aug 2008 20:14:06 -0400
Message-ID: <g7vtch$8v2$1@ger.gmane.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: uugg.de
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
In-Reply-To: <1218645375.3540.71.camel@localhost.localdomain>
Cc: malware-list@lists.printk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this was posted in linux.kernel, before I realized there was a 
linux.kernel.malware.    Hope it helps your discussion)

(FYI. Dazuko may have trailblazed some of the issues now under
discussion re: libmalware.so. It has worked well for me. It used to be
an LKM, it is now a source patch. It is used in a number of commercial
products)


<http://dazuko.dnsalias.org/wiki/index.php/Main_Page>

"A Virtual Device Driver to Allow Online File Access Control

A common interface is needed, which allows userland applications to
perform online file access control. Dazuko aims to provide that interface."

FWIW, I'm not associated with Dazuko or Antivir; I've been happily using
Dazuko with AntiVir for a year or so.

1. AntiVir includes numerous Linux signatures as well as Windows. So I
scan both 'ix downloads, as well as the process of compiling new software.

2. Other AntiMalwares are using Dazuko, though many are scanning for
Windows malware only.

3. The AntiVir/Dazuko combination with full heuristics has blocked
access to clearly dangerous JS scripts in my browser cache.

4. IMHO, what is needed is a Dazuko or libmalware/Integrity database
link. If an md5 of an executable or script is new or has changed, access
is blocked 'til a response to a popup is given. Access can be blocked;
one-time allowed; or permanently allowed, in which case the md5 is updated.

Hope This Helps.

<next msg>


Andi Kleen wrote:
 > 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com> writes:
 >
 >> (FYI. Dazuko may have trailblazed some of the issues now under
 >> discussion re: libmalware.so. It has worked well for me.
 >
 > Against what exactly did it protect you? Please give a concrete example.
 >
 > -Andi
 >

1. This came in a few minutes ago:

Aug 13 14:56:31 tux antivir[6381]: AntiVir ALERT: [EML/FakeLink.F]
/jail/tbird/root/.thunderbird/0r2957kg.default/Mail/L
ocal Folders/Junk.XXX <<< Contains detection pattern of EML/FakeLink.F
in EML form

2. I have not retained the logs of "suspicious scripts" in my browser,
but have come across perhaps 4 blocked scripts within the last month.
Admittedly at dodgy sites.

XSS attacks are platform independent, and are a significant concern.


Please note that when I say it has worked well for me, I am not saying
that it has saved my bacon! :-)

1. I am referring to the mechanics of having the Kernel/userland app
stop processing when it finds a malware signature or heuristic detection.

2. Am also referring to the totally manageable (IMHO) overhead.

I've mentioned my experience with Dazuko/antivir only because it may be
useful to the ongoing discussion about the nature of libmalware.so.

3. I am frankly waiting for a bug to get into my upstream distribution
chain - through a hijacking or some wonderful DNS prank - at which point
I ..hope.. a signature or heuristic will block my root-enabled make install.

4. Again, my hope for libmalware.so/dazuko is a realtime
integrity-management link.

<end posts>

HTH

p.s. The question has developed, should this monitor root activities. 
IMHO, the answer is a definite YES!  We are most vulnerable during 
software updating; AntiMailware signatures may stop the compilation or 
installation of a Trojan - by root.






