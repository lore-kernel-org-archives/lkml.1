Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZCaGuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZCaGuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbZCaGtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:49:50 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:55661 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZCaGtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=XLA+V1sO965GhQTQeXaiuqWU8RhUCyvvlHLq0T/wjGBHny++zH3JJB0RST2GjPthyp
         3dMzuZHE3E2+/AEVFsGJf+K3ne0QLc8t9sNKZdI3uzWAwoqneCu67LALrJ/3eus9uEeb
         ttFivyMzJzpNjrs68matRj4/8nQEBu2BLfwNU=
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 14:49:46 +0800
Message-ID: <804dabb00903302349j5bdbabeaxbbd09291b1cf6e4@mail.gmail.com>
Subject: "make oldconfig" problem
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I do "make oldconfig" on the latest linus git tree, I got:

make oldconfig
scripts/kconfig/conf -o arch/x86/Kconfig
usr/Kconfig:145:warning: defaults for choice values not supported
#
# configuration written to .config
#

But checking usr/Kconfig:145:

if INITRAMFS_SOURCE=""
# The builtin initramfs is so small so we don't want to bug the user...

config INITRAMFS_COMPRESSION_NONE
        bool
        default y

endif

I cannot understand the source of errors as well?   Frederic, any ideas?

-- 
Regards,
Peter Teoh
