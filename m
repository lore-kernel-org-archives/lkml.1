Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbXHEQ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbXHEQ1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXHEQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:27:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:26502 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXHEQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=SZ+jVWDD/sWgZ0aBymd3B+SHOzrqZ20R7KW6ZncIamQalD8Xy+q51yzWBAr1LcSC+JF1E7FbE922k5vmXe0FoXT7pImmiLD5qu5JBoq3RScYlSfodTYVL4P5nDC4bMllzdIQIp1qz0BGb2Nw5lVOxiDolJl9LhMCRIdkhL4iu+M=
Message-ID: <46B5FA29.2070509@googlemail.com>
Date: Sun, 05 Aug 2007 18:26:17 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hugh Dickins <hugh@veritas.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Denis Sadykov <denis.m.sadykov@intel.com>, dth <dth@dth.net>
Subject: [1/3] 2.6.23-rc2: known regressions
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2
Trent Piepho                           2



Unclassified

Subject         : console is messed up after resume from s2ram or switching to console from X
References      : http://lkml.org/lkml/2007/8/4/6
Last known good : ?
Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
Caused-By       : ?
Handled-By      : H. Peter Anvin <hpa@zytor.com>
                  Antonino A. Daplas <adaplas@gmail.com>
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged



ACPI

Subject         : 2.6.23-rc1-git10 hangs on boot - needs "acpi=off"
References      : http://lkml.org/lkml/2007/8/2/24
Last known good : ?
Submitter       : Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : T60 ACPI issues/THINKPAD_ACPI_INPUT_ENABLED seems regressive
References      : http://lkml.org/lkml/2007/8/1/198
                  http://lkml.org/lkml/2007/8/1/176
Last known good : ?
Submitter       : Michael S. Tsirkin <mst@dev.mellanox.co.il>
                  Hugh Dickins <hugh@veritas.com>
Caused-By       : ?
Handled-By      : Henrique de Moraes Holschuh <hmh@hmh.eng.br>
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
