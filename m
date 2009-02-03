Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZBCRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZBCRzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBCRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:54:50 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZBCRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:54:49 -0500
X-Greylist: delayed 3882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 12:54:48 EST
Date: Tue, 3 Feb 2009 17:22:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: wenji.huang@oracle.com
Cc: linux-serial@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the warning of uninitialized value in
 driver/serial/8250.c
Message-ID: <20090203172223.4ef378d0@the-village.bc.nu>
In-Reply-To: <4986B86E.3030604@oracle.com>
References: <4986B86E.3030604@oracle.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 17:10:06 +0800
Wenji Huang <wenji.huang@oracle.com> wrote:

> This patch is to remove the the warning of uninitialized i in 
> driver/serial/8250.c
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>

NAK - your gcc is wrong. Use a newer gcc and the warning goes away.

