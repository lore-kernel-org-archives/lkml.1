Return-Path: <linux-kernel-owner+w=401wt.eu-S2992754AbXCGXog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992754AbXCGXog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992767AbXCGXof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:44:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55702 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992763AbXCGXob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:44:31 -0500
Date: Thu, 8 Mar 2007 00:48:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: f_owner.lock and file->pos updates
Message-ID: <20070308004853.4f5a090c@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703071117n474f02f7rcc630f0415530aed@mail.gmail.com>
References: <f2b55d220703071117n474f02f7rcc630f0415530aed@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 11:17:36 -0800
"Michael K. Edwards" <medwards.linux@gmail.com> wrote:

> Suppose I want to create an atomic llseek+writev operation.  Is this
> more or less sufficient:

The right way IMHO would be to do the work that was done for pread/pwrite
and implement preadv/pwritev. The moment you want to do atomic things
with the file->f_pos instead of doing it with a local passed pos value it
gets ugly.. why do you need to do it with f_pos ?

Alan
