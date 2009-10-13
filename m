Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbZJMCIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbZJMCIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZJMCIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:08:40 -0400
Received: from smtp113.rog.mail.re2.yahoo.com ([68.142.225.229]:46885 "HELO
	smtp113.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752996AbZJMCIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:08:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=vbslAWLtzRraX7wAbhEGuC6ZHRSP+4B2cgHb3Kd7Wc69dyUO3SDYUK4HLsRVOCW5l32saWrrsfrmDhDztg5tqsz+oFfL70BFA+QoK6nfo1jDpXeVX+U1qTodKdn9nTPQ/MRmBOMWQq16SvyfFXFqPken77K1pFdjANZ/4/dF0wQ=  ;
X-YMail-OSG: QR6l.DMVM1mXNxgwHKkOeNO8xp6XXfqD8cXbiYwdwLbwhaeuGPopEA8BEXcmp1FlRQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.32-rc4] + EXT4 corruption
Date: Mon, 12 Oct 2009 22:07:49 -0400
User-Agent: KMail/1.12.90 (Linux/2.6.32-rc4-custom; KDE/4.3.69; x86_64; svn-1027797; 2009-09-23)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122207.50140.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, 

I somehow managed to corrupt some of my filesystem.

What I did was this:

in /etc/modprobe.d/alsa-base.conf (Kubuntu)

I added:

install snd-aloop /sbin/modprobe snd-aloop

Saved it, then ran, modprobe snd-aloop, the system started spawning many 
copies of modprobe, then machine started going though a swap storm, could not 
reboot safely, hit power button on laptop. When the system came back up, EXT4 
greeted me with severe errors on some opened files. It did repair filesystem 
however. It corrupted some configuration files that were open at the time of 
the shutdown.

I'm guessing no matter how much you attempt to replay a journal you still can 
get corruption such as this?

Thanks, 
Shawn.
