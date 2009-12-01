Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZLANaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZLANaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZLANap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:30:45 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:41191 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLANao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:30:44 -0500
Message-ID: <4B151A86.1060505@ladisch.de>
Date: Tue, 01 Dec 2009 14:30:46 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mai Daftedar <mai.daftedar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Signal from kernel space to user space
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com>
In-Reply-To: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mai Daftedar wrote:
>    Im still new to the kernel development world :)and  I was wondering
> what functions I can use in the kernel space for a signal to be sent
> to the userspace

kill_pid_(info) is to be preferred over send_sig_info because it ensures
that the destination process has the same identity (a plain pid number
might have wrappend around and be in use by another process).

However, why are you using a signal? What information are you trying to
send, and why wouldn't eventfd or a plain device thaz becomes readable
be a better solution?

> I tryed a number of examples I found after I did some googling that
> used the API "send_sig_info" however nothing worked :(

Because something in that code is wrong.  I can't tell you more about
the details because my crystal ball is in repair.


Best regards,
Clemens
