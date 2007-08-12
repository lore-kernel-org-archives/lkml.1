Return-Path: <linux-kernel-owner+w=401wt.eu-S938929AbXHLVCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938929AbXHLVCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761193AbXHLVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:01:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbXHLVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:01:56 -0400
Message-ID: <46BF7451.2020306@zytor.com>
Date: Sun, 12 Aug 2007 13:57:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Al Viro <viro@ftp.linux.org.uk>, Mark Cannon <random.bits@rogers.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
References: <200708101724.26724.random.bits@rogers.com> <46BCFE01.2040703@zytor.com> <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr> <200708121539.48332.random.bits@rogers.com> <Pine.LNX.4.64.0708122147440.28963@fbirervta.pbzchgretzou.qr> <20070812202320.GE21089@ftp.linux.org.uk> <Pine.LNX.4.64.0708122253360.28963@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708122253360.28963@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 12 2007 21:23, Al Viro wrote:
>>> pivot_root is atomic afaict, for `mount --move` (which I think Al meant 
>>> which MS_MOVE - or some C program using mount(2) of your own), you'd 
>>> need multiple calls to mount.
>> Move itself is done by a single syscall anyway...
>>
> Yes, but you need needed 2 mounts, 1 chdir and one chroot. Plus, you 
> have not freed the data in the rootfs. (Well, neither does 
> pivot_root, but run-init from klibc will.)

Yes, which is why it is highly inappropriate for this particular case,
since they have multiple roots that they presumably don't want deleted!

	-hpa
