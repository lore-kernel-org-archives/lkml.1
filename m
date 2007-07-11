Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXGKVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXGKVNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762295AbXGKVNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:13:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:26674 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761097AbXGKVNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JnuqVTGBfS6ZauDjyHSMaERgGrS4NLE//mG/h1NKclSX3eDfNOCtEyTaDLimHV6/6y4bRKILyxF6pKGPl5PZLRN0FgVni7P/yk48NFeMP9G3w/dy4Z7Hvz/VX9X3ENuBEYOyC/jqFnYZsibUyZ4urej/3/P/yFmOkyTLD9i/3g0=
Message-ID: <d3dac270707111413j42ac7a0eif032636a9018df66@mail.gmail.com>
Date: Wed, 11 Jul 2007 14:13:12 -0700
From: "Max Alekseyev" <maxale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 booting hangs after "INIT: version 2.86 booting"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have trouble with booting linux kernel 2.6.22 from kernel.org on my
AMD dual-Opteron 250 system.
The booting stops right after printing line "INIT: version 2.86
booting". Nothing happens after that, but it is not a hardware hang as
keyboard leds respond to pressing Caps/Num lock keys.

If I boot with init=/bin/sh parameter I successfully get into the
shell but attempts to run scripts from /etc/rcS.d/ all end up with
Segmentation faults, e.g.:

# sh -x /etc/rcS.d/S01glibc.sh
++ uname -s
Segmentation fault

I am not sure where these segfaults happen as running programs like
'uname' directly from the shell works OK.

The 2.6.22 configuration is derived from the working 2.6.21 one. The
kernel 2.6.21 boots on the very same system without any problems.
Any suggestions?

Thanks,
Max
