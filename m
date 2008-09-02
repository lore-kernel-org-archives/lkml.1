Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIBFnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIBFnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYIBFna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:43:30 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:52341 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751925AbYIBFn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:43:28 -0400
Date: Tue, 2 Sep 2008 07:43:22 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080902054322.GA7154@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <20080830205143.GA9726@anita> <48BBCF98.4070003@kernel.org> <20080901174657.GA2114@anita> <48BCC28E.5030009@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <48BCC28E.5030009@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am 2008-09-02 06:35 +0200 schrieb Tejun Heo:

> > Seems this stuff is kinda new since 2.6.25?
> 
> I think it's more circa 2.6.22 but in my memory terms, which sucks,
> that's a lifetime before so I don't really remember.  :-)

Okay :-)

> Hmm... someone is scheduling EH incessantly without any error or action
> set.  Can you please try the attached patch?

I did and put here all dmesg gave me. Do you want to get the whole stuff
from the beginning? /var/log/messages has ist, but it is 416k, I put it
on a ftp server somewhere out there then. Or is something else
recommended?

Konsti



-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace.txt"

3b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1587, comm: syslog-ng Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80236140>] 0xffffffff80236140
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803ea01e>] 0xffffffff803ea01e
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80236140>] 0xffffffff80236140
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80236140>] 0xffffffff80236140
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80236140>] 0xffffffff80236140
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803ea01e>] 0xffffffff803ea01e
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1587, comm: syslog-ng Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1587, comm: syslog-ng Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff802787df>] 0xffffffff802787df
 [<ffffffff802787d3>] 0xffffffff802787d3
 [<ffffffff8027a1f8>] 0xffffffff8027a1f8
 [<ffffffff8027aedd>] 0xffffffff8027aedd
 [<ffffffff8027b027>] 0xffffffff8027b027
 [<ffffffff80279e1d>] 0xffffffff80279e1d
 [<ffffffff8027be77>] 0xffffffff8027be77
 [<ffffffff80211779>] 0xffffffff80211779
 [<ffffffff80273cc4>] 0xffffffff80273cc4
 [<ffffffff80273b93>] 0xffffffff80273b93
 [<ffffffff80273dd7>] 0xffffffff80273dd7
 [<ffffffff8020b63b>] 0xffffffff8020b63b

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cbd0>] 0xffffffff8023cbd0
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff8033b440>] 0xffffffff8033b440
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cbd0>] 0xffffffff8023cbd0
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff8024a9fc>] 0xffffffff8024a9fc
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1587, comm: syslog-ng Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff8024a9fc>] 0xffffffff8024a9fc
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff8022b423>] 0xffffffff8022b423
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t3
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cbd0>] 0xffffffff8023cbd0
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff8024a9fc>] 0xffffffff8024a9fc
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t2
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 1587, comm: syslog-ng Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI> 
ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80236140>] 0xffffffff80236140
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff80221d92>] 0xffffffff80221d92
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff8033b440>] 0xffffffff8033b440
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cbd0>] 0xffffffff8023cbd0
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cc0c>] 0xffffffff8023cc0c
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff8033b440>] 0xffffffff8033b440
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff80328f6d>] 0xffffffff80328f6d
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff8022f400>] 0xffffffff8022f400
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80218ad0>] 0xffffffff80218ad0
 [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1: XXX about_to_do 6
ata1: XXX EH_SET_PENDING
Pid: 0, comm: swapper Not tainted 2.6.27-rc3 #5

Call Trace:
 <IRQ>  [<ffffffff8023cbd0>] 0xffffffff8023cbd0
 [<ffffffff803b9953>] 0xffffffff803b9953
 [<ffffffff803b9aed>] 0xffffffff803b9aed
 [<ffffffff803b9be7>] 0xffffffff803b9be7
 [<ffffffff803c052a>] 0xffffffff803c052a
 [<ffffffff803c06f3>] 0xffffffff803c06f3
 [<ffffffff802488d4>] 0xffffffff802488d4
 [<ffffffff80249c31>] 0xffffffff80249c31
 [<ffffffff8020e26c>] 0xffffffff8020e26c
 [<ffffffff8020bb41>] 0xffffffff8020bb41
 <EOI>  [<ffffffff80211dfa>] 0xffffffff80211dfa
 [<ffffffff8020a6d9>] 0xffffffff8020a6d9

ata1: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen t4
ata1: XXX about_to_do 6
ata1: EH complete

--gKMricLos+KVdGMg--
