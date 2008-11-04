Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYKDJ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYKDJ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKDJ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:57:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:54037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYKDJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pjJIFPzcxALWJY8fcudPq5lxEtPikoFimd1xO3VPFpuwRDIBrIM9cjGHhNjBJLhLkT
         Y26a7559c/InvhGeu3l2DceypXCH3MmWKtmCWN+SbLp5OrB/VaSaER1aINj7dWRXIgG6
         Aei7MtCcsd5wt6YkrC4RkM4wBBcX6WqnHcg1s=
Date: Tue, 4 Nov 2008 13:00:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081104100050.GA10398@x200.localdomain>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> # uname -a
> Linux ubuntu 2.6.28-rc2-next-20081031 #60 SMP Sat Nov 1 13:19:49 CET
> 2008 i686 GNU/Linux
> # prelink -mRf /sbin/udevd
> # ./a.out /proc/4764/exe
> warning: /proc/4764/exe: got return value 38, expected 11
> 2f7362696e2f756465766400fffffffffdfffffffffffff7ffffbfff202864656c6574656429
> /sbin/udevd                  (deleted)

reproduced

As I said previously, kmemcheck rocks (slowly). :-)
