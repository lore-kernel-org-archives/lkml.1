Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXH2P2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXH2P2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXH2P2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:28:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:62561 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXH2P2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=GeyzDUkjsIJ2JcKlpZgWNvP+u1CAKFLF5jSGHNibxS/CDr8WPc28Ygji+UWlttUaSyNpoh6jGvwssDyNGWOcVyETDyTrffbUPdGbrpbCFcASGW/tohGg4mA/ZvMOekXTCHXXN2MrPk97a/B3m5iJkyIhWL3NsewQvg74FwzLKwk=
Message-ID: <46D59052.6040609@googlemail.com>
Date: Wed, 29 Aug 2007 17:27:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Michael Sedkowski <sedmich@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       "Ivan N. Zlatev" <contact@i-nz.net>, Thomas Meyer <thomas@m3y3r.de>,
       dth <dth@dth.net>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
References: <46D58CC6.4020605@googlemail.com>
In-Reply-To: <46D58CC6.4020605@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Hugh Dickins                           4
Al Viro                                3
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



ACPI

Subject         : 2.6.23-rc4: maxcpus still broken
References      : http://lkml.org/lkml/2007/8/28/87
Last known good : ?
Submitter       : Alexey Dobriyan <adobriyan@sw.ru>
Caused-By       : Len Brown <len.brown@intel.com>
                  commit 61ec7567db103d537329b0db9a887db570431ff4
Handled-By      : Len Brown <len.brown@intel.com>
Status          : problem is being debugged

Subject         : MCFG bug on hp nx6310
References      : http://lkml.org/lkml/2007/8/8/252
Last known good : ?
Submitter       : Michael Sedkowski <sedmich@gmail.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : 2.6.23-rc1-git10 hangs on boot - needs "acpi=off"
References      : http://lkml.org/lkml/2007/8/2/24
Last known good : ?
Submitter       : Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
Caused-By       : ?
Handled-By      : Len Brown <len.brown@intel.com>
Status          : problem is being debugged



ALSA

Subject         : Master volume control broken
References      : http://lkml.org/lkml/2007/8/18/46
Last known good : ?
Submitter       : Thomas Meyer <thomas@m3y3r.de>
Caused-By       : Ivan N. Zlatev <contact@i-nz.net>
                  commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
Handled-By      : Ivan N. Zlatev <contact@i-nz.net>
Status          : problem is being debugged



CPUFREQ

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
                  http://lkml.org/lkml/2007/7/29/371
Last known good : ?
Submitter       : dth <dth@dth.net>
Caused-By       : Len Brown <lenb@kernel.org>
                  commit f79e3185dd0f8650022518d7624c876d8929061b
Handled-By      : Len Brown <lenb@kernel.org>
Status          : problem is being debugged



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
