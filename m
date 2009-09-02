Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZIBHW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZIBHW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 03:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZIBHWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 03:22:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10528 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZIBHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 03:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cGHBJDyEtgaMdXRiWLNYfTwL4vGTKAZe0OHH2AfiXY5/WZl4ogL+rFfrYG8g7B/T5a
         AQrONAHo1EbUlArrN6k6YF71L/nWH10yoYDlEq0cE5KVnsDb60b6FOOt6hFAJGDiInG8
         8vXicJ3wYQZcl2VgAg/lT1K5763PUnSmdoG3Y=
MIME-Version: 1.0
In-Reply-To: <b410963b0908290221s4ed3d66fm50ea2862cf7500f5@mail.gmail.com>
References: <b410963b0908290221s4ed3d66fm50ea2862cf7500f5@mail.gmail.com>
Date: Wed, 2 Sep 2009 10:22:56 +0300
Message-ID: <b410963b0909020022q68101ed8n5cdafdcbdabea230@mail.gmail.com>
Subject: Re: r8169 NETDEV WATCHDOG: eth0: transmit timed out [8/8]
From: roma1390 <roma1390@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dillow <dave@thedillows.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Can you please confirm this by sending your /proc/interrupt info:
>	cat /proc/interrupts | grep eth0

# cat /proc/interrupts | grep eth0
1274:  425472357          0          0          0          0
0          0          0   PCI-MSI-edge      eth0

Please add me next time into cc.

sorry but debian stable provides latest 2.6.26-2-amd64
curent workaround is to use: driver r8168.
