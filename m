Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZDBOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZDBOCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZDBOCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:02:44 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:46722 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZDBOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JlBI/M5NzMqgiijI3gFCmt/ZHVc4Is2vCGT6eNKmwMA23EGvGXwk9kPty9XVIgEugu
         qVEYWrwB1iVvhNg8mjxml94noLGhmOCfzFZklsTHOcFoqM2FZF0b0M+FUp7LFJEoQnGw
         T6ig8pktRWw1+uR8THYnQ7/s9eohYw4I6lL7Y=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 11:02:41 -0300
Message-ID: <159a870e0904020702q3c528b8u77cebf834d607e3f@mail.gmail.com>
Subject: RAID performance / tuning?
From: Tiago Freire <tiago.freire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML,

I am a long-time linux user, but not a C dev.
I have been using software RAID since I had an Athlon 64 3000, which
at the time took a toll of up to 30% of the CPU time on big writes (4
200GB disks on RAID 5), if my memory serves me well.
If you can get me some clarifications, I would be incredibly grateful.
Shouldn't software RAID always surpass hardware, given fast enough hardware?
Why is it that software RAID on current systems still gets less
performance than hardware counterparts?
Also, are there any knobs/pulleys/ledgers in the linux kernel so that
I can maximize RAID operation performance?
Given that our current bottleneck is the disk IO, it would take a
sincere effort to saturate the CPU with raid/disk operations (you'd
need lots and lots of disks).

Best regards
