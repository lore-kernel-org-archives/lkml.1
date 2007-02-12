Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXBLLmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXBLLmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964870AbXBLLmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:42:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:43599 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857AbXBLLmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:42:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mPQKaU+FBnripJoP3dwUo6ogfuE3nACcvIoQQI28fpkIR2QD97fnkyze07tYiR7Io/31/sur6zCXqbP1SkBDSmPYJonSreh8x9gpyPpKQRmVe8wOgBtf02A20ZVC5WS68iXtjaLnt1h6wwpp+otazyNqBnHXt6J6fun8hDv7As8=
Message-ID: <cab162590702120342p1efea5c1ua345c2cafa81f569@mail.gmail.com>
Date: Mon, 12 Feb 2007 12:42:22 +0100
From: "Milan Markovic" <zivotinja@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Found trivial error in linux-headers-2.6.17-11-generic/include/linux/tty.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded the kernel on my Kubuntu 6.10 to 2.6.17-11-generic and had
a lot of trouble compiling my softmodem driver.
Apparently it was, among others, because of a mistake in kernel-headers
this is what I've found in tty.h

$ cat -n /usr/src/linux-headers-2.6.17-11-generic/include/linux/tty.h
| grep Define -C 3
    83   */
    84  #define TTY_NORMAL      0
    85  #define TTY_BREAK       1
    86  #Define Tty_Frame       2
    87  #define TTY_PARITY      3
    88  #define TTY_OVERRUN     4
    89

I don't know whether it is Ubuntu-related error, or it came  from the
top, and I wasn't really sure to whom should I address this error
report.
Hope this will help.

Greetings,
M
