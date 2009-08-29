Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZH2JQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZH2JQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 05:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZH2JQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 05:16:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:30154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZH2JQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 05:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=N7Na7YN6P43qmu2SrEBKNOVYJnlamnE/HCnVV+AWhkXMhb0rbjl5WSjvcdpRmtEifa
         iQddbclSc2y163+dlgEMVjJ1bdhyfYGdG0A1BaZN7bGzJ2xPXBR0Pc0bksaXy2/QYj9q
         4QY8QbC0tKYBh0/H/RJKSWAuecLg4tD/jeZD0=
MIME-Version: 1.0
Date: Sat, 29 Aug 2009 12:16:43 +0300
Message-ID: <b410963b0908290216x19206aa6o4458bb55b5578a04@mail.gmail.com>
Subject: r8169 NETDEV WATCHDOG: eth0: transmit timed out [0/8]
From: roma1390 <roma1390@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 3 different r8169 devices on 2 servers (from 2 server so 100% of
population) we getting

NETDEV WATCHDOG: eth0: transmit timed out

with all bad consequences (stalled transmition) about up to 2 minutes or more.

Server doing up to 20Mbps. Mysql + apache + php. about 500 http
request / second.
These stall's is related only to r8169 (device or driver). Change to
other r8169 doesn't help. Helps only change to e1000 (other netcards
not tried, but maybe they will work too).

Attached logs from 2 servers. On srv5 motherboard was changed with
integrated r8169 but problem persist.

This behavior is know on internet, with no know workaround. Please
mark this driver as unstable/experimental or please move it to staging
tree.

Thanks in advance.
