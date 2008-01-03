Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYACPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYACPE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYACPEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:04:49 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52732 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYACPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:04:48 -0500
Date: Thu, 3 Jan 2008 16:04:47 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: linux-kernel@vger.kernel.org
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
In-Reply-To: <83783877@web.de>
Message-ID: <Pine.LNX.4.64.0801031604130.26693@fbirervta.pbzchgretzou.qr>
References: <83783877@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 3 2008 15:39, devzero@web.de wrote:
>fantastic, thanks!
>
>unfortunately......
>
>opensuse103:/home/roland/serialcons # ./mytioccons
>ioctl: Device or resource busy
>
>but i`m not deep enough into programming to understand this.
>

>int main(void)
>{
>int fd = open("/dev/ttyS0", O_RDWR);
>int errno;

This errno is so out of place.

>
>ioctl(0, TIOCCONS, NULL);
>
>if (ioctl(fd, TIOCCONS, NULL) < 0)
>        printf("ioctl: %s\n", strerror(errno));
>}
