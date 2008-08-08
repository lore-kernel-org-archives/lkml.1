Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYHHNdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYHHNdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYHHNda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:33:30 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:47272 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYHHNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:33:29 -0400
Message-ID: <37357.166.70.238.45.1218201115.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <82e4877d0808072133q58150665r355c9bf140d0b42c@mail.gmail.com>
References: <82e4877d0808072133q58150665r355c9bf140d0b42c@mail.gmail.com>
Date: Fri, 8 Aug 2008 07:11:55 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: jmerkey@wolfmountaingroup.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff,
>
> This definitely looks interesting and it even worked for me - breaking
> in couple of times, trying various commands and resuming back to X all
> works. Never tried a kernel debugger before but most things were
> obvious after I figured out that I need to be on the VT to be able to
> press break and be dropped into the debugger.
>
> That said, it triggers soft lockups on all the suspended CPUs - not a
> big deal and probably expected, but I guess that can be cured by
> touching the soft lockup watch dog or something?

Yep.

It does with this kprobes interface, I noticed it last night.  I will run
this down.  I am touching the watchdog in the keyboard handler.

Jeff

>
> Thanks
>
> Parag
>


