Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbXHXRkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbXHXRkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764166AbXHXRjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:39:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:8533 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471AbXHXRjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=nUGtVjh8omxx1NfOPhQBs5XRpv5riw4Yw0u52CCN8fYbRguqCHjPhrQLCIVhQzExeBXTqaRiytXfw/76d1fYJXqvyBlPHUCRUrL9oeYBDE4ZEuW4WH1dmarOOCW+XXOUczLyZBPvh+DIhLthG1qB0qBW9aiW8rGsAOwOS78vGyE=
Message-ID: <46CF17B4.1060403@googlemail.com>
Date: Fri, 24 Aug 2007 19:39:00 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Alex Hunsaker <badalex@gmail.com>,
       szczekut@wit.edu.pl, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [1/2] 2.6.23-rc3: known regressions with patches v3
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



Unclassified

Subject         : 8250 claims non existing device blocking IO port
References      : http://lkml.org/lkml/2007/8/18/20
Last known good : ?
Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
Caused-By       : ?
Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch           : http://lkml.org/lkml/2007/8/21/291
Status          : patch was suggested

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



ACPI

Subject         : Broken hotkeys on ASUS A6Km notebook with 2.6.23-rc3/2.6.23-rc3 fails to boot (acpi)
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8909
                  http://bugzilla.kernel.org/show_bug.cgi?id=8919
Last known good : 2.6.23-rc2
Submitter       : <szczekut@wit.edu.pl>
                  Alex Hunsaker <badalex@gmail.com>
Caused-By       : ?
Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12494
Status          : patch available



MMC

Subject         : Unable to access memory card reader anymore
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8885
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12438
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
