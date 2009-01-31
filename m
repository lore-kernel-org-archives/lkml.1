Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZAaKBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZAaKBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZAaKBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:01:16 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43904 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZAaKBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:01:16 -0500
X-Auth-Info: 7YIJkza3f4zMRI2nJ5qjEInZ9Bpb+uglNHggqMpvyOQ=
To: Andrew Morton <akpm@linux-foundation.org>
cc: Grant Erickson <gerickson@nuovations.com>, linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <20090130142825.e63ee797.akpm@linux-foundation.org>
References: <20090130115108.592ba38d.akpm@linux-foundation.org> <C5A8B8CD.143B5%gerickson@nuovations.com> <20090130142825.e63ee797.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Fri, 30 Jan 2009 14:28:25 -0800."
Date: Sat, 31 Jan 2009 11:01:13 +0100
Message-Id: <20090131100113.6E1B983644C3@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

In message <20090130142825.e63ee797.akpm@linux-foundation.org> you wrote:
> 
> It shouldn't be too hard to cook up some way of copying some data into
> th log buffer before the kernel itself has put anything in there, if
> that's all which is needed.

Agreed, but we also want to get the data back into the shared log
buffer when the system crashes someone presses the reset button. The
log buffer shall survive reboots -that's the basic requirment of the
implementation, and this is what makes it a bit more complicated.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Microsoft Multitasking:
                     several applications can crash at the same time.
