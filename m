Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYJAKer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYJAKer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYJAKeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:34:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46206 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753521AbYJAKea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:34:30 -0400
Date: Wed, 1 Oct 2008 11:34:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
 uninitialized
Message-ID: <20081001113418.1b23ccb7@lxorguk.ukuu.org.uk>
In-Reply-To: <1222849017-10896-1-git-send-email-steven@uplinklabs.net>
References: <20081001080150.GC25832@elte.hu>
	<1222849017-10896-1-git-send-email-steven@uplinklabs.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2008 01:16:57 -0700
Steven Noonan <steven@uplinklabs.net> wrote:

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

I'd rather have the warning than that particular ugly in the source
of the serial/tty code. It doesn't fit the pattern of attributes used
elsewhere in the code (__unused __user etc).

Alan
