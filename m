Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXERNUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXERNUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXERNT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:19:57 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:22173 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbXERNT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DNMRcQ0W3BeqgsMaaI+wsHOakMCLCwQ+h3MVLi6p1ZOPnBmChZtc0R5s5shodgGKaiWujZuUWGOT5F/kiLfGmVLR3tj4LowkcIJOkO603IawztZhVE1NTZFQ/1OJ1ipv9vvdN2IB8tuk7kwZ3Kpi1piuHypkjlBOwqjeWFUB7z4=
Message-ID: <1865922a0705180619g2a997c2ch5d13be3e023630e0@mail.gmail.com>
Date: Fri, 18 May 2007 16:19:56 +0300
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Subject: Re: Fork Bombing Attack
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
	 <4051.1179414105@turing-police.cc.vt.edu>
	 <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Anand Jahagirdar <anandjigar@gmail.com> wrote:
> Hello All
>            I tried to execute a program which creates 8152 process.(
> i=0; while( i<14) i++ fork(); )  with ulimit 8200. This program
> created 8152 processes and then stopped and came back to command
> prompt. this proves that my machine do have sufficient resources to
> create 8000 processes.
>
>            I found one more interesting thing on the same machine
> having FC6 distribution and Linux Kernel 2.6.18. i have set "ulimit -u
> 100". after setting this limit i tried to execute fork bombing program
> with guest account. after executing it
>
> expected result:-  guest uesr should not able to fork another single
> process when it reaches to 100 processes count.
>
> actual result :-  kernel allow me to create another processes without
> giving error. due to this i tried to execute same fork bombing program
> on another terminal with guest account and this fork bombing attack
> killed the box completely and machine needed reboot.
>

I think if you want resource limiting per _UID_ (and not per _process_
as you did), you should use PAM module pam_limits.so. You can edit
those limits using the file /etc/security/limits.conf

Regards,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
