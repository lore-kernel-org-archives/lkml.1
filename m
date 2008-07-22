Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYGVSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYGVSgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGVSgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:36:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:13703 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYGVSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NPtJuCTiqmxA5omv5u5jwqSGMkXRDQwAaZvHnjT/8VtbcQYNYtKduUZ+P5eZXJl+ky
         ucQNDMhnFPQGzHQPrIME7tDOQDH3iRE1I5Ekkoj3KUsm84HwsrPBgjN1nOnmwsUUmlCj
         8wPN+nK1fMOG3k3SIsC6DPWC3vZFBX9qYIWPA=
Message-ID: <8fb5fa2d0807221136v2b92a34cv2c1fe4a5e9a126bc@mail.gmail.com>
Date: Tue, 22 Jul 2008 11:36:22 -0700
From: "Buddy Lumpkin" <buddy.lumpkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: measuring memory pressure, expose freepages and zone watermarks under /proc perhaps?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Would it be possible to expose the value of the zone watermarks and
freepages for each zone under /proc in order to present a clear
picture of what the memory pressure on a system looks like?

Running: watch -n1 cat /proc/meminfo,  you can get a pretty good feel
for how much memory pressure each zone is under by watching HighFree
and LowFree fall to a certain point, and then increase in a cyclical
fashion, but it would be absolutely wonderful if some metrics could be
exposed that give us a better view into the amount of memory pressure
a system is under.

In my case, I would like to write an agent that distills this
information in a way that allows users to set alarm thresholds for
their applications. The allocstall metric in /proc/vmstat is nice for
indicating whether a 2.6 kernel has fallen under extreme memory
pressure, but I have applications that are affected noticeably by even
modest amounts of memory pressure make a very noticeable difference in
latency.

Lastly, if anyone knows of a good method for measuring various levels
of memory pressure on 2.4 and/or 2.6 kernels, please share them.

Thanks in advance,

--Buddy
