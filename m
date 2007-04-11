Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbXDKPvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbXDKPvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXDKPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:51:40 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:43654 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXDKPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:51:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.1016.199225.111768@smtp.charter.net>
Date: Wed, 11 Apr 2007 11:51:20 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olaf@aepfle.de>, Dave Dillow <dave@thedillows.org>,
       Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com>
	<200704100351.33699.gene.heskett@gmail.com>
	<Pine.LNX.4.61.0704101809440.21664@yvahk01.tjqt.qr>
	<200704102354.23766.gene.heskett@gmail.com>
	<Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

Jan> On Apr 10 2007 23:54, Gene Heskett wrote:
>>>>> 
>>>>> So fix tar to not do silly things.
>>>>> Kernel major:minor numbers are not stable.
>>>> 
>>>> YOU Tell that to the tar/star people, they are flabbergasted that its
>>>> not stable.  It apparently is for every other OS tar can be run on.
>>> 
>>> FreeBSD also seems to be quite "dynamic".
>>> /dev/da0 is (0,92) for the 'fixit shell' -- how about you?
>>> 
>> I don't have such a beast here.  Whats that supposed to do?

Jan> Well I was just pointing out that Linux is not the only one to
Jan> have device numbers (for promiment block-backed storage) that can
Jan> move across reboots.

I guess one work around would be to export your local filesystems via
NFS and then have amanda back them up that way, which means gnutar
should then ignore the devmajor and devminor numbers.  

Or you could just use a hack of the perl script 'tarcust' to hack the
minor/major numbers stored in the index files, and make them match the
current major/minor pair for each filesystem just before you do a
backup.   

A total hack, but probably what I would do, since gtar should (IMNSHO)
just ignore the devmajor/devminor and just go by the name.  It's not
like the sysadmin can't shoot himself in the foot anyway.

Or, again, get away from Amanda and tar and instead move to Bacula.
Smarter software.

John
