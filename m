Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYAHPTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYAHPTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYAHPTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:19:47 -0500
Received: from smtp.ono.com ([62.42.230.12]:45989 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752399AbYAHPTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:19:46 -0500
Date: Tue, 8 Jan 2008 16:18:53 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5
 under heavy load  ?
Message-ID: <20080108161853.6efee208@werewolf>
In-Reply-To: <2A722A49-F024-44E9-9FC8-7B714FB25626@neuf.fr>
References: <fa.NcJePXcdrF+7E7oXv5ULIxogTYI@ifi.uio.no>
	<4782C3DB.1090201@shaw.ca>
	<2A722A49-F024-44E9-9FC8-7B714FB25626@neuf.fr>
X-Mailer: Claws Mail 3.2.0cvs23 (GTK+ 2.12.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 15:52:35 +0100, Guillaume Laurès <guillaume-laures@neuf.fr> wrote:


> > ata5.00: exception Emask 0x0 SAct 0x1f02 SErr 0x0 action 0x2 frozen
> > ata5.00: cmd 60/40:08:8f:eb:67/00:00:03:00:00/40 tag 1 cdb 0x0 data  
> > 32768 in
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

Perhaps it is a generic libata bug, I have similar problems without
any array.
See this message:

http://marc.info/?l=linux-kernel&m=119975354031937&w=2

It's an ICH5 controller, not nv. This was rc7.
I have now gone back to rc6 to see if problems persist.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
