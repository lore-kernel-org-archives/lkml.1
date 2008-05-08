Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYEHGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYEHGgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYEHGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:36:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:47530 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYEHGgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VzCCTRQw4iaadpkFu8MiNTbGXO7eOOLcTvI+2gGCLZNZboZMt2tcRnIoUqot0FfCX3MKslz03GVMEEssWgyHO40I65TP4A+hqLWPDhzNKU7XaPDKOHs1YpRmSS8exL2SYExs/RENkfqsF1uclVt8uShjtxroG2KkXscaVaeRdfs=
Message-ID: <e2e108260805072336p6b29f11o287ac3c5cab9295a@mail.gmail.com>
Date: Thu, 8 May 2008 08:36:03 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Strange mptbase / mptscsih kernel messages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have made a setup with four servers, where each server is configured
as follows:
* Four Intel Xeon E5130 CPU cores.
* 8 GB RAM.
* SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 04),
* 16 disks in a RAID6 setup (md).
* Linux 2.6.24.6 kernel.

There is a lot of data being written to the RAID6 array: about 50 MB/s
on each server. There are two kinds of messages that appear:

(1)
[74887.117650] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
Code={Abort}, SubCode(0x0403)

(2)
[74917.081454] mptscsih: ioc0: attempting task abort! (sc=ffff8100a18a7180)
[74917.081461] sd 0:0:15:0: [sdp] CDB: Write(10): 2a 00 1c fe 61 93 00 00 20 00
[74918.409801] mptbase: ioc0: LogInfo(0x31140000): Originator={PL},
Code={IO Executed}, SubCode(0x0000)
[74918.639801] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8100a18a7180)

These messages appear a few times per day. Anyone any idea what the
meaning is of these messages and what the cause of these messages is ?

Bart.
