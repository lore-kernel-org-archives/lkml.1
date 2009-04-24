Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZDXKW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZDXKW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZDXKWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:22:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56035 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169AbZDXKWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:22:47 -0400
Date: Fri, 24 Apr 2009 11:23:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rutkov Denis <dendron2000@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High kernel CPU usage when copying files
Message-ID: <20090424112348.64fb5c73@lxorguk.ukuu.org.uk>
In-Reply-To: <E1LxIDf-0004qD-00.dendron2000-mail-ru@f159.mail.ru>
References: <E1LxIDf-0004qD-00.dendron2000-mail-ru@f159.mail.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whenever I copy files I got very high CPU usage from kernel. I tested this with ext3, ext4 and fat32 file systems. To trace the problem I installed oprofile and debug kernel image. I ran the profiler during file copying and saw that there are many calls to copy_to_user_ll and copy_from_user_ll functions. So I have two questions:
> 
> 1. Is this normal I get so many of those function calls?

Yes

> 2. What can I do to further trace this bug?


Are you seeing high CPU usage or just a lot of D state processes (blocked
waiting I/O) ?

Alan
