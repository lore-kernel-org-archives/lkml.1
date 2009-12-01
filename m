Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZLASOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZLASOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZLASOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:14:02 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36736 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZLASOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:14:01 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 13:14:01 EST
X-AuthUser: davidel@xmailserver.org
Date: Tue, 1 Dec 2009 10:05:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Mark Hounschell <markh@compro.net>
cc: Clemens Ladisch <clemens@ladisch.de>,
       Mai Daftedar <mai.daftedar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Signal from kernel space to user space
In-Reply-To: <4B1533B0.1030007@compro.net>
Message-ID: <alpine.DEB.2.00.0912011003290.20551@makko.or.mcafeemobile.com>
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com> <4B151A86.1060505@ladisch.de> <4B1533B0.1030007@compro.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Mark Hounschell wrote:

> If no "information" is required, which of these are the fastest, say from an interrupt handler?
> I have a PCI card that handles external interrupts from the outside world and does nothing but
> report those external interrupts to userland. We use send_sig or wake_up_process depending
> on whether userland is going to wait for it or not. If there is a better/faster way I would be
> very interested.

eventfd is. eventfd_signal() is also callable from non-sleeping contexts.


- Davide


