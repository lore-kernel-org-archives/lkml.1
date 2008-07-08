Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGHIIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGHIIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYGHII0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:08:26 -0400
Received: from nebensachen.de ([195.34.83.29]:39286 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYGHIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:08:25 -0400
X-Hashcash: 1:20:080708:monnier@iro.umontreal.ca::rxMZyNIP5YCNVAQZ:0000000000000000000000000000000000000DsL/
X-Hashcash: 1:20:080708:linux-kernel@vger.kernel.org::E+Xu4s1F9Krp0g2h:0000000000000000000000000000000005BQp
From: Elias Oltmanns <eo@nebensachen.de>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keeping track of spin-down/spin-up and causes of spin-up?
References: <jwvskuku9jr.fsf-monnier+gmane.linux.kernel@gnu.org>
Date: Tue, 08 Jul 2008 10:07:12 +0200
In-Reply-To: <jwvskuku9jr.fsf-monnier+gmane.linux.kernel@gnu.org> (Stefan
	Monnier's message of "Tue, 08 Jul 2008 03:25:18 -0400")
Message-ID: <87hcb0kde7.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With reference to the subject, are you a physicist by any chance? ;-)

Stefan Monnier <monnier@iro.umontreal.ca> wrote:
[...]
> In any case, I have a machine here whose disk keeps spinning back up
> on a regular basis, and I can't seem to find any correlated event.
> Is there a tool that can help me track down the reason why the disk
> is accessed?

You can do

# echo 1 > /proc/sys/vm/block_dump

temporarily, so all disk accesses will be logged in dmesg. You should
seriously consider stopping klogd first because your log files will be
swamped otherwise.

That reminds me that syslog could well be the reason for your disk to
spin up frequently. But then you might have thought of that already.

Regards,

Elias
