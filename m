Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXL0PTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXL0PTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 10:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXL0PTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 10:19:37 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20610 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbXL0PTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:19:36 -0500
Message-ID: <4773C283.5070408@msgid.tls.msk.ru>
Date: Thu, 27 Dec 2007 18:19:31 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mxser, remove it
References: <1198762722-3222-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1198762722-3222-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> (Old) mxser is obsoleted by mxser_new and scheduled for removal on Dec 2007.
> Remove it.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  Documentation/feature-removal-schedule.txt |    8 -
>  drivers/char/Kconfig                       |   11 -
>  drivers/char/Makefile                      |    1 -
>  drivers/char/mxser.c                       | 3141 ----------------------------
>  drivers/char/mxser.h                       |  441 ----
>  5 files changed, 0 insertions(+), 3602 deletions(-)
>  delete mode 100644 drivers/char/mxser.c
>  delete mode 100644 drivers/char/mxser.h

While we're at it, how about adding a modalias for mxser_new
module with old (being removed) name, so that users who're
using the old module will not scream?  I mean, in order for
`modprobe mxser' to load mxser_new module.

/mjt
