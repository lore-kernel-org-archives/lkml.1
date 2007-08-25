Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbXHYQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbXHYQoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXHYQoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:44:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35417 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbXHYQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:44:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D05C42.4010606@s5r6.in-berlin.de>
Date: Sat, 25 Aug 2007 18:43:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Martin K. Petersen" <mkp@mkp.net>
CC: Gregor Jasny <gjasny@googlemail.com>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: Corrupted filesystem with new Firewire stack
References: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>	<46C3EE1F.40309@s5r6.in-berlin.de> <yq1ps1m5odq.fsf@sermon.lab.mkp.net> <46C6F3C7.3070002@s5r6.in-berlin.de>
In-Reply-To: <46C6F3C7.3070002@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Martin K. Petersen wrote:
>> Happens here on both a G4 and an intel Mini.  Both running FC7.
>>
>> Aug 17 08:24:08 mini kernel: firewire_sbp2: status write for unknown orb
>> Aug 17 08:25:08 mini kernel: firewire_sbp2: sbp2_scsi_abort
>> Aug 17 08:26:36 mini kernel: firewire_sbp2: status write for unknown orb
>> Aug 17 08:27:36 mini kernel: firewire_sbp2: sbp2_scsi_abort
>> Aug 17 08:33:51 mini kernel: firewire_sbp2: status write for unknown orb
>> Aug 17 08:34:51 mini kernel: firewire_sbp2: sbp2_scsi_abort

The infrequent occurrences of this on my test setup vanished after
Kristian's patch.  The patch is now in linux1394-2.6.git and in
http://me.in-berlin.de/~s5r6/linux1394/updates/.
-- 
Stefan Richter
-=====-=-=== =--- ==--=
http://arcgraph.de/sr/
