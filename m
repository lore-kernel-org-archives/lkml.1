Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZEBU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZEBU5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbZEBU5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:57:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:56685 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZEBU5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Yk3Q74xmapTo4KpA7E0baK0PgXya0dVYr5YfKbNQIkU8EmMAz9GL55XEzxg/2HDd6y
         /2i+isibm6SpsOEhYcBnZLWwlAhLx/GZpA0upS9fWUXURBS2hKiNua+zgI5RJ4r+88+3
         wo7ciX8+UM4Mdz3dQo88486JM5nHcD3qBDV1I=
MIME-Version: 1.0
Date: Sat, 2 May 2009 16:57:13 -0400
Message-ID: <feb515800905021357r7735efe3xc6c940ae5ccc0005@mail.gmail.com>
Subject: cannot trace cpu_idle
From: you_bear zhou <youbear.zhou@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hei guys,

I'm running a para-virtualized Suse VM on Xen 3.2.0.  I use printk to
print out some message within cpu_idle() function
(arch/x86/kernel/process_32.c), from the hypervisor's record the VM is
already idle for a while, but I didn't see any message print out from
cpu_idle().

Can anyone explain this to me?

Thank you!
