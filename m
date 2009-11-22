Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZKVMVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZKVMVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZKVMV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:21:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60842 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754570AbZKVMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:21:29 -0500
Date: Sun, 22 Nov 2009 12:23:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
In-Reply-To: <20091122063926.GA18224@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091122063926.GA18224@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 07:39:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> (Cc:-ed Alan and Linus - mail repeated below. eot.)

I saw it and replied already. The kernel now queues the work for the pty
as it does normal tty devices. If the CPU load is that low and nothing
else is happening it makes me wonder what the scheduler thinks it is
doing ?

Alan
