Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbXE0SSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbXE0SSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 14:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXE0SSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 14:18:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbXE0SSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 14:18:01 -0400
Message-ID: <4659CB4C.7080105@anagramm.de>
Date: Sun, 27 May 2007 20:17:48 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tommy Vercetti <vercetti@zlew.org>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
References: <200705261505.38109@gj-laptop>	<200705261746.01568@gj-laptop>	<2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>	<200705271222.30169@gj-laptop> <20070527130228.3731ff4d@the-village.bc.nu>
In-Reply-To: <20070527130228.3731ff4d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/8UvvK+44dOooJvf0G72JYUpsYvdKRsKi1RoU
 0W4qoddl/cX6rnmv20pfVHITmbMKPBvofI9oGg1y6ePJNCq6p/
 zjy+frX/gb2h22sba++6Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan!

Alan Cox schrieb:
>> yeah, and they say unix FSes don't need defragmentation.... my bottom...
> 
> Provided they don't get within about 5-10% of full a lot of the time Unix
> file systems generally don't  - especially with preallocators. Reiser3 is
> not a traditional unix file system, its very different to almost any
> other fs, and it does need defragmenting.

Just FYI:
http://ck.kolivas.org/apps/defrag/
http://sourceforge.net/projects/davtools/
defragmentation seems to be a minor issue.

After reiser3 (kernel 2.6.18.1 or so) crashed(*) badly with
some data loss on a production server can you recommed
a _safe_ and good performing filesystem for an
compile and test server (lots of small files).

(*) rm ~/Maildir while it was fed with courier-imap and
pressed CTRL-C to interrupt that trashed some of the files in
~/Maildir. It needed a --rebuild-tree.


Best greets,

Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
