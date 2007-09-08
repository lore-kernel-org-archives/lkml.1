Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXIHLNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXIHLNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXIHLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:12:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:46022 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXIHLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=OsQlr8N2GmClaCKSZim67PteMREKIMqQ3GAuE7yHphVQAv0bzkGyoSG/GHwulfBwNvSCLKbW5uYBHyUDW9PqtJhAz6aiq+uvGly29bXfVuhiosRyj4ZGzAtVqknQR7eVNLMsdFGPJbGkMMVikV3MvhabmTLy71filsCNr3Darq0=
Message-ID: <46E28351.8050900@googlemail.com>
Date: Sat, 08 Sep 2007 13:11:13 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>, Ian Kent <raven@themaw.net>,
       autofs@linux.kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [2/4] 2.6.23-rc5: known regressions v2
References: <46E27DEF.7060109@googlemail.com>
In-Reply-To: <46E27DEF.7060109@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
David S. Miller                        3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



FS

Subject         : umount triggers a warning in jfs and takes almost a minute
References      : http://lkml.org/lkml/2007/9/4/73
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall
References      : http://lkml.org/lkml/2007/9/4/53
Last known good : ?
Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



USB

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown

Subject         : USB hard disk broken in 2.6.23-rc3 (autosuspend related)
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8892
Last known good : ?
Submitter       : Roman Jarosz <kedgedev@centrum.cz>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Workaround      : echo -1 >/sys/bus/usb/devices/1-4/power/autosuspend
Status          : possible hardware problem



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
