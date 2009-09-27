Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZI0J4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZI0J4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 05:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZI0J4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 05:56:53 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:53527 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZI0J4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 05:56:53 -0400
Message-ID: <4ABF36DF.90101@upmc.fr>
Date: Sun, 27 Sep 2009 11:56:47 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel 2.6.31.1 the following files in

/usr/src/linux-2.6.31.1/include/asm-generic/

include <asm/bitsperlong.h> 

while they should #include <asm-generic/bitsperlong.h>

int-l64.h:#include <asm/bitsperlong.h>
int-ll64.h:#include <asm/bitsperlong.h>
msgbuf.h:#include <asm/bitsperlong.h>
posix_types.h:#include <asm/bitsperlong.h>
sembuf.h:#include <asm/bitsperlong.h>
shmbuf.h:#include <asm/bitsperlong.h>
stat.h:#include <asm/bitsperlong.h>
swab.h:#include <asm/bitsperlong.h>
unistd.h:#include <asm/bitsperlong.h>

Regards,

Bernard Pidoux
