Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYLNIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYLNIVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYLNILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:11:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:56392 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbYLNILh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:mime-version:content-type:content-transfer-encoding:message-id
         :date:to:cc:subject:in-reply-to:references:x-mailer;
        b=YKuKTnpk16HU2SYIB98FXNjmXil1j+FdT29l+8jJsHVaQimnV04wDcLEdvyKzzsmqc
         zRtoDj1v4/+fXJFk9DIVKCGHDPRX1WsG+8zPIfT/zTR3Q3HhfQiQPpTzVt+dLqAfHDCa
         48F0qNGd1xVjv9p8ayUIk5tW4YBzazIcA4pKo=
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18756.48950.20615.440764@localhost.localdomain>
Date: Sun, 14 Dec 2008 13:39:26 +0530
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       lrodriguez@atheros.com, jmalinen@atheros.com,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: BUG - ath9k keep on disconnecting in 2.6.28-rc8
In-Reply-To: <3f9a31f40812132354k6f9e7b80o30d3236687dffba0@mail.gmail.com>
References: <3f9a31f40812132354k6f9e7b80o30d3236687dffba0@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.3.1 (i686-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh wrote:
> I am facing problem with 2.6.28-rc8, ath9k keep on disconnecting.

[...]

> wlan0: authenticate with AP 00:11:95:9e:df:f6
> ForceXPAon: 0
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authenticate with AP 00:11:95:9e:df:f6
> wlan0: authentication with AP 00:11:95:9e:df:f6 timed out

A number of updates have gone into the wireless-testing tree.
You can use that tree or compat-wireless to get the latest driver
and check if the problem persists.

Sujith
