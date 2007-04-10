Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXDJXCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXDJXCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXDJXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:02:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:33026 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161023AbXDJXCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mybmwUUL411JmiCUFv50qiuWdhPN874NAchvYLtMI4UetxdHoSukhaG9f9bERlB2QOgmmxG+yNDjVEXopPtq/0RIXNezX2Qk5IPQYl0opQMGBYJrZqJZcnVH2zIqMETTldA8XJ9oXof5MFvIJtjLdSXxzPdJsZY/eNqYl+TRL6E=
Message-ID: <1f8291090704101602q41e30a7doe79f3606643b628b@mail.gmail.com>
Date: Tue, 10 Apr 2007 16:02:01 -0700
From: "doctor raid" <drraid@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.20.4 Unaligned address
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1] kernel errors reporting unaligned access of memory
[2]  The following two lines iterate twice a piece, about once every 2 minutes:

      Kernel unaligned access at TPC[79c344] arpt_do_table+0x3cc/0x640
       Kernel unaligned access at TPC[79c33c] arpt_do_table+0x3c4/0x640

[3]  ...

[4] Linux version 2.6.20.4 (root@outland) (gcc version 3.3.5 (Debian
1:3.3.5-13)) #3
 Fri Apr 6 18:08:28 PDT 2007

[7] This is running on a Netra t1 105 (sparc)

/proc/cpu:


cpu             : TI UltraSparc IIi (Sabre)

fpu             : UltraSparc IIi integrated FPU
prom            : OBP 3.10.27 2000/06/22 16:45
type            : sun4u
ncpus probed    : 1
ncpus active    : 1
D$ parity tl1   : 0
I$ parity tl1   : 0
Cpu0Bogo        : 880.43
Cpu0ClkTck      : 000000001a3a605f
MMU Type        : Spitfire

I can attach my .config if necessary, but don't want to clutter this
email with any
unnecessary data.

-brandon
