Return-Path: <linux-kernel-owner+w=401wt.eu-S937292AbXHHROA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937292AbXHHROA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936373AbXHHRNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:13:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5643 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763590AbXHHRNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=tSfUYkqRQ+ebjIGWiWdZY1jdJn3+XKLg9uQgwRX3a5jM6vCAfjGKlCY0mVhIQzO3q/m79V6RPzyR62qHWBE36UPKi9OCv1/GMV/rEXO9ZI91DNwUnl+xVMaX5ugFy0XdAoIUtrja+rSRvJkWiht1XU68FzoSzPLdn8J1c8Fnaig=
Message-ID: <46B9F98E.9020406@googlemail.com>
Date: Wed, 08 Aug 2007 19:12:46 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Jan Dittmer <jdi@l4x.org>,
       Netdev <netdev@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Renninger <trenn@suse.de>,
       Stephen Hemminger <shemminger@osdl.org>,
       Florian Lohoff <flo@rfc822.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [1/2] 2.6.23-rc2: known regressions with patches v2
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
Peter Zijlstra                         2
Trent Piepho                           2



Unclassified

Subject         : Kconfig prompts without help text
References      : http://lkml.org/lkml/2007/7/16/326
Last known good : ?
Submitter       : Stefan Richter <stefanr@s5r6.in-berlin.de>
Caused-By       : ?
Handled-By      : Jan Engelhardt <jengelh@linux01.gwdg.de>
Patch           : http://lkml.org/lkml/2007/7/18/236
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



FS

Subject         : NFSv4 poops itself
References      : http://lkml.org/lkml/2007/7/27/144
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org> 
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/7/27/183
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

Subject         : sky2 boot crash in sky2_mac_intr
References      : http://lkml.org/lkml/2007/7/24/91
Last known good : ?
Submitter       : Florian Lohoff <flo@rfc822.org>
Caused-By       : 
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Patch           : http://marc.info/?l=linux-netdev&m=118651402523966&w=2
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
