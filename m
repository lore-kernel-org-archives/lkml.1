Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYDGUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYDGUvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYDGUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:51:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46910 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbYDGUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:51:45 -0400
Date: Thu, 3 Apr 2008 18:37:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Xavier <x.guimard@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Proposed patch for IDE missing commands
Message-ID: <20080403183741.736fde6c@the-village.bc.nu>
In-Reply-To: <47F47324.80108@free.fr>
References: <47F47324.80108@free.fr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 08:03:16 +0200
Xavier <x.guimard@free.fr> wrote:

> Hi all,
> 
> I'm working for the french Gendarmerie Nationale and we've decided to 
> publish our patch for the kernel that provides some missing IDE commands 
> to access to protected areas (HPA and DCO).

Code looks fine barring style oddities but
- Almost all vendors are moving to libata
- I don't understand why you cannot use the existing SG_IO interface to
issue the needed commands without adding more kernel bits ?

Alan
