Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbZKNLyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbZKNLyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 06:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZKNLyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 06:54:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:54579 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbZKNLyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UUd85wFF47ujzc8hnsege21NPiPdLUeFg05dknGNhBKnuK006y5FmlT4Ys6encpnjt
         /ei8NL7GUERShbIYJPKozn2U+4vRGkLKdb+8q97tYt9NMnlvDFjCJUWErmYd6Pv5Awdm
         w6aw+nNJFmYo6mm0yQiSChH1Di1XdayvQ+WlQ=
Message-ID: <4AFE95DE.3070308@gmail.com>
Date: Sat, 14 Nov 2009 14:34:54 +0300
From: Andrey Polovov <andrey.polovov@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Getting HDD serial in kernel space
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I had a necessity to get HDD serial number in my kernel module.
In user space I can do it so:

    fd = open( "/dev/sda", O_RDONLY|O_NONBLOCK );
    ioctl( fd, HDIO_GET_IDENTITY, &id );
    printf( "Serial: %s", id.serial_no );

How can I do it in kernel space (it is one hdd in machine, plugged with
SATA)?

