Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbZLQWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbZLQWts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765462AbZLQWtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:49:46 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:53955 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762979AbZLQWtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vZdhBkFAgVO5CB8Ccw2Oy++3c9a7tHysQGSkQkDBGBswWq09vTBsf5DV/f63a4HkOt
         Umb1+n9Nm9oZGs1ZHr6j+JV9UZzSQJduYnGrfBscN30SZS5gGjZvUMFI/unbr02P3692
         ON5gWHpucx/kwOppU7dVqKtuKbaYtQiNzzvg4=
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 17:49:44 -0500
Message-ID: <e75d22a90912171449s7262b0fag41b045526ed35091@mail.gmail.com>
Subject: tg3 and bcm5703 cards - rx dropped packets
From: Michael Di Domenico <mdidomenico4@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have several Dell t3500 workstation which we've installed PCI-X
BroadCom cards specifically the BCM5703 Fiber cards.

We're also using RedHat v5.4 2.6.18-164.6.1 kernel with all the stock drivers.

For some reason which i cannot determine, when we read a large amount
of data into the workstation we see the RX dropped counter steadily
(rapidly) increase.

This only happens on reads, if we do a write operation we do not see TX drops.

We've tested this between all types of devices (nfs, http) servers at
various points in the network and the only common thing is the NIC.

I'd think it was just a bad nic, but we have several nics across t3500
and t3400's doing this.

Is anyone aware of such an issue?  Can anyone recommend some steps i
can take to isolate why the packets are being dropped?

I hooked up wireshark on one of the servers while we were running the
test and i see a lot of Duplicate ACK and TCP Checksum errors, in the
communications between the two hosts.  But im not sure that actually
points to anything.

Thanks
