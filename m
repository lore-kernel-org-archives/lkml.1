Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXDLIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXDLIBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945930AbXDLIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:01:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:61221 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945929AbXDLIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dcHWO5IY39+xpC8pn0EtYpQnjHuNZbXzklSA1ME+Gfa85p7bYPT56hBEep7DjV7/VxWhyzk14vP84p/Ueut9o4/D3yRcm6Vxc/u6X/hp62ASnZq00qZVWijs8EIWaDFLzHVB9l6IOA9LwEPHt2tK/4JVMZj+ywt9VqHCoeHa3ak=
Message-ID: <9a8748490704120101o7ae2645ei12bb096971da6dfe@mail.gmail.com>
Date: Thu, 12 Apr 2007 10:01:07 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.13.4 kernel Oops - proc related
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Yesterday one of my servers Oops'ed on me :-(
The server was running an old 2.6.13.4 kernel.
I got a screenshot of the Oops which is available here :
http://www.kernel.org/pub/linux/kernel/people/juhl/images/2.6.13.4-crash.png

Even though this is a rather old kernel, I wanted to report the crash
just in case it's not a known bug. If it is already known and fixed,
then just ignore this mail.

Userspace is also rather old (but the kernel was not build on this box
with that ancient compiler, it's just running here) :

# scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux srv.mydomain.net 2.6.13.4 #1 SMP Wed Nov 16 11:13:51 CET 2005 i686 unknown

Gnu C                  2.96
Gnu make               3.79.1
binutils               2.11.93.0.2
util-linux             2.11n
mount                  2.11n
module-init-tools      3.0-pre1
e2fsprogs              1.27
reiserfsprogs          2001------------->
reiser4progs           fsck.reiser4:
quota-tools            3.06.
nfs-utils              1.0.5
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.11
Net-tools              1.60
Console-tools          0.3.3
Sh-utils               2.0.11
Modules Loaded         iptable_nat


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
