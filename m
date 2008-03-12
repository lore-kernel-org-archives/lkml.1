Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYCLIxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYCLIxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYCLIw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:52:56 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44501 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLIwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:52:55 -0400
Date: Wed, 12 Mar 2008 09:53:07 +0100
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: "Prakhar Krishna" <prakhar2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to compile kernel so it automatically reboots upon a crash
 instead of generating stack trace and then hang.
Message-ID: <20080312095307.4873c750@bull.net>
In-Reply-To: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
References: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Prakhar,

On Tue, 11 Mar 2008 23:52:00 -0500 "Prakhar Krishna" <prakhar2@gmail.com> wrote:

> [I did search the mailing lists archives and the Web but did not find an answer,
>  apololgies if this is duplicate question]
> 
> i need my linux box to automatically reboot if it ever runs into a
> kernel panic/crash etc.
> For my production evvironment, it is not desired that kernel generate the stack
> trace and then wait there. We want it to reboot and comeback up again.
> 
> if this has already been answered (i seriously think it should have
> been), please
> direct me to the answer else any details would be helpful.
> 

  This screams 'hardware watchdog' to me, as there are situations when the kernel
is completely hung.

  Sebastien.
