Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZF1NZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZF1NZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZF1NZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:25:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36872 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158AbZF1NZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:25:28 -0400
Date: Sun, 28 Jun 2009 14:26:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Char: cyclades, fix isa+module build
Message-ID: <20090628142642.14967528@lxorguk.ukuu.org.uk>
In-Reply-To: <1246194822-17628-1-git-send-email-jirislaby@gmail.com>
References: <1246194822-17628-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 15:13:42 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> When CONFIG_ISA and MODULES is turned on, a build will fail with
> the following error:
> drivers/char/cyclades.c:3332: error: assignment of read-only location
> 
> Deconstify that particular isa structure.

Already fixed

Alan
