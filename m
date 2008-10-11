Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYJKMx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYJKMx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 08:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYJKMxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 08:53:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:51744 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYJKMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=n2sipJ/hecJ2TTY6teupI+Weprjvo46IQnrR3NtFMbwn/Wp1OK3IsBH27dNMaM5uql
         q/HDGFduRDtxYV487C3zLQkpSDlglwqghbGPZGKVKnXmyD0sahq7MTe/QaogJPmCj8MU
         9YmdJa+iIv7JbsL5jpl6woFRQyuBLlvVfoeIc=
Message-ID: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
Date: Sat, 11 Oct 2008 14:53:16 +0200
From: "Philip Stark" <heller.barde@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27 seems to break something with DSL
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry, I didn't lurk before making my first posting to this list,
but it seemed to me that this might be an important problem/bug (if it
is one).

first off, my network infrastructure:

"internet" --(magic*)-- DSL Modem --(DHCP)-- Router --(DHCP)-- Computer
* PPPsomething i guess...

My observations so far:

with kernel =< 2.6.26 i can connect to the rest of the world perfectly
(ping works and i can browse "the internet")

now with kernel 2.6.27, i.e with all the release candidates and also
with the final version from yesterday i can ping anything just fine,
but i can't browse. that is when i 'wget kernel.org' it resolves the
address into the correct IP and then goes on to 'connecting' just to
grind to a complete halt. after some time of course it times out.
it seems to  be related to the packet  size because ping only seems to
work because it uses small packets. if i increase the ping size up to
1000 bytes, it fails as well. (while it does work on 2.6.26)

oh and it is the same problem on the wireless and the wired interface.
on 2 different laptops and on my desktop (which have different
networking chips, two intel and one realtek)

best Regards
Philip Stark

PS: if i horribly misposted, please slap me across the face and ignore me :)
