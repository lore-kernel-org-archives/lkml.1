Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbYCXRjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbYCXRjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYCXRj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:39:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13038 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035AbYCXRjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:39:25 -0400
Message-ID: <9d2cd630803241039m79c47754v6562404133a61274@mail.gmail.com>
Date: Mon, 24 Mar 2008 18:39:22 +0100
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Burning CDs as user produces coasters (Plextor drive)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since some time burning ISO CD images as user fails.
Wodim stops during OPC and the kernel prints some messages:

scsi: unknown opcode 0xe9
scsi: unknown opcode 0xed
scsi: unknown opcode 0xf5
scsi: unknown opcode 0xeb

If I burn as root, everything works fine. The used CD writer is a
"PLEXTOR  DVDR   PX-712A   1.09". I've seen in the wodim/cdrecord
sources that plextor drives are handled different from other drives.

Do you know what the above listed commands are for?
Maybe they could be included in blk_verify_command?
If your'e not sure about the dangerousness maybe as a config option?

Thanks,
Gregor
