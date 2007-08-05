Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXHEQ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXHEQ3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXHEQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:28:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:26502 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477AbXHEQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=DS2oLss36xpzdlf6rIx2yh96n045JMCYxWhsiyihmB7TlO9y1aT75aq6ZgvgOWXm5Dha/4WF22taOCXq4n9pshhcti2wxffbzKtU/H+d/YRd+hjmAxVyLlRMZgFBY6lmIISV7IxndsezqJrid8nAVbdXy9YemYBI9rcduPX23ZQ=
Message-ID: <46B5FA4C.2070700@googlemail.com>
Date: Sun, 05 Aug 2007 18:26:52 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Dittmer <jdi@l4x.org>, Thomas Renninger <trenn@suse.de>,
       Netdev <netdev@vger.kernel.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, Seokmann Ju <seokmann.ju@qlogic.com>,
       Richard Lary <rlary@us.ibm.com>
Subject: Re: [2/2] 2.6.23-rc2: known regressions with patches
References: <46B5F93A.1020100@googlemail.com>
In-Reply-To: <46B5F93A.1020100@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc2
with patches available.

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



Memory management

Subject         : [bug] SLUB & freeing locks
References      : http://lkml.org/lkml/2007/7/26/90
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : Peter Zijlstra <peterz@infradead.org>
Patch           : http://lkml.org/lkml/2007/7/26/97
Status          : patch available



Modpost

Subject         : modpost bug breaks ia64 cross compilation
References      : http://lkml.org/lkml/2007/7/27/30
                  http://lkml.org/lkml/2007/7/27/418
Last known good : ?
Submitter       : Jan Dittmer <jdi@l4x.org>
Caused-By       : Thomas Renninger <trenn@suse.de>
                  commit 29b71a1ca74491fab9fed09e9d835d840d042690
Handled-By      : ?
Patch           : http://lkml.org/lkml/2007/8/2/211
Status          : patch was suggested



Networking

Subject         : tg3 dead after s2ram
References      : http://lkml.org/lkml/2007/7/31/121
Last known good : ?
Submitter       : Joachim Deguara <joachim.deguara@amd.com>
Caused-By       : ?
Handled-By      : Michael Chan <mchan@broadcom.com>
Patch           : http://lkml.org/lkml/2007/8/2/288
Status          : patch available



SCSI

Subject         : qla2xyz broken in current Linus tree
References      : http://marc.info/?l=linux-scsi&m=118581420308892&w=2
Last known good : ?
Submitter       : Matthew Wilcox <matthew@wil.cx>
Caused-By       : Seokmann Ju <seokmann.ju@qlogic.com>
                  commit 281afe1947d855661754850de29d7530b2ff
Handled-By      : Seokmann Ju <seokmann.ju@qlogic.com>
Patch           : http://marc.info/?l=linux-scsi&m=118581884800073&w=2
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
