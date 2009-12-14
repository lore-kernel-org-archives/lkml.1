Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZLNVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZLNVlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZLNVlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:41:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53043 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZLNVlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:41:44 -0500
To: Petr =?iso-8859-1?Q?Tit=ECra?= <petr@titera.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wrong atime on recent kernels
From: Andi Kleen <andi@firstfloor.org>
References: <4B26AB7E.9020208@titera.eu>
Date: Mon, 14 Dec 2009 22:41:38 +0100
In-Reply-To: <4B26AB7E.9020208@titera.eu> (Petr =?iso-8859-1?Q?Tit=ECra's?=
 message of "Mon, 14 Dec 2009 22:17:50 +0100")
Message-ID: <87d42hxmgd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Titìra <petr@titera.eu> writes:

> Hello,
>
>       I see some strange file modification times recently. It seems to
> me that in some situations, kernel allows to set nanoseconds part of
> file access, modification or change time  to 100000000 ns. Problem
> seems to be in some generic part of kernel because I see it on several
> different filesysytems (ext4 and nilf2). These is I've got during my
> testing on kernel  2.6.32-tip-08309-gad8e75a.

Do you know which kernel was the last one to be not showing this?

Is 2.6.32 plain ok?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
