Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZI0M1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZI0M1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 08:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZI0M1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 08:27:54 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61484 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZI0M1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 08:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=fMacpDhaqz17vLpRVCdA2urXbcglm6TRK8bmWYOY9CjURlw7e5ZB3XF0UAClnibBmq
         e5I3bHBeo4lkeySBQTgsiSixLkP/m3pUCBogHbIvyJtPSgTYo8gABg1uK4njRegxtbHx
         K9NjO2aYQHB+jmLxP8ZobAxI/FHxnH+Uj3Tjc=
MIME-Version: 1.0
Date: Sun, 27 Sep 2009 14:27:55 +0200
Message-ID: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com>
Subject: ext4/reiser3/btr directory create/read perf
From: wbrana@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I executed benchmark which creates and reads 10000 directories.
It is much slower with ext4 than with reiser3 or btrfs.

ext4 without dir_index
void cfs::vdirs_create(): 7754 msec
void cfs::vdirs_read(): 3363 msec

reiser3
void cfs::vdirs_create(): 1173 msec
void cfs::vdirs_read(): 421 msec

btrfs
void cfs::vdirs_create(): 1331 msec
void cfs::vdirs_read(): 567 msec

MD RAID10-f2, 64 kB chunk size

Source code:
http://www.sendspace.com/file/bconaa
depends on Qt Core, has hard-coded paths
