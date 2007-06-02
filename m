Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbXFBTLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbXFBTLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXFBTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:11:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1821 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653AbXFBTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=M74GEBzHVHem2r5zlhfzsz8ykR3CzsKxzRMASn+Dp01L+9BQl2SFBhNGK8kSZo/frHsa8c0scLdetlDZx8gtecxupvPuoS0sRC53nHpN8ZxQszIqD2PULnD0XcICOl2A/T0XYi2aYXvF0XHBVYKvJf7PpwxGkxXqUi2jvY/Bx1Y=
Message-ID: <4661C0DA.7040308@gmail.com>
Date: Sat, 02 Jun 2007 13:11:22 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070520)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com
Subject: 2.6.22-rc3-mm1 reiser4 bug
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All appears to work fine, until I try to boot a kernel with a Reiser4 /
partition.  Then I get endless errors of the sort:

[  206.349450] sd 1:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK

(See attached dmesg for more, I only sent the first 1,000 lines, it goes
on until a hard reboot.)

The same partition and the same kernel work great as long as that
partition isn't the current system root.  The same kernel and the same
hard drive works fine as long as the partition is formatted ReiserFS.
