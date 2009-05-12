Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbZELP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbZELP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZELP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:56:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59746 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbZELP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Qw/xj+GOuYTZ6CbvG34rAL1GYplfMXBaQk5ZvBgG8LR4Jc1pFlPgpfRpHBdA3tLm0c
         91Y0UJ/4Y72jQXDIIfG0Jul/8Mw0OMdIANOIWz/iFPYeELfMUcQIxfRRLlUQeYZ2KM6n
         VFL78iTbzQ+E56OV3Dzy9o9rLRNMFLH5+Tnts=
MIME-Version: 1.0
Date: Tue, 12 May 2009 19:56:14 +0400
Message-ID: <a4423d670905120856w7c36fe01v949289342662b7be@mail.gmail.com>
Subject: cpm_uart: build failure
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>, linux-serial@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I found this problem during randconfig tests for ppc64.

drivers/serial/cpm_uart/cpm_uart_core.c: In function 'cpm_put_poll_char':
drivers/serial/cpm_uart/cpm_uart_core.c:1002: error: implicit
declaration of function 'cpm_uart_early_write'

I cannot find any definition nor git-log history for cpm_uart_early_write().

Is it really bug from Jul 23 11:30:16 2008?

commit 8e21d04c077c50284bdad10fda8f8cea674458e1
Author: Jason Wessel <jason.wessel@windriver.com>
Date:   Wed Jul 23 11:30:16 2008 -0500

    kgdb: kgdboc console poll hooks for cpm uart

    Add in console polling hooks for the cpm uart for use with kgdb and
    kgdboc.

    Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
    CC: galak@kernel.crashing.org
