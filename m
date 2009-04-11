Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZDKO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZDKO42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 10:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZDKO4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 10:56:18 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61049 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZDKO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 10:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=azDiWbgFs0lGRCvs7EhtC7vUmLooFomqV5D9nxKqlnb5EIY9qoXtXo7eeJqTRQfOhc
         q3Xds5kEJTcgn6cA4DcDQVMLeAiBIHXoTtSaSwqecScP0xw0oqgkMpGbNhCZY4hG7JiA
         hjLHpkJmfyuuJ2QXsanA8gC9x2pSChkcq40es=
Date: Sat, 11 Apr 2009 15:56:12 +0100
From: "Tiago =?ISO-8859-1?B?U2lt9WVz?= Batista" <tiagosbatista@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: High latency on /sys/class/thermal
Message-ID: <20090411155612.5808570c@ua.pt>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Yesterday, I recompiled my kernel (git + tuxonice)
v2.6.30-rc1-1002-gac91f91, there were a couple of issues, the main one
is ilustrated bellow.

I am not familiar with the kernel code, but if you give me some
pointers, I will be glad to investigate this further

$time cat /sys/class/thermal/thermal_zone0/temp 
34000

real	0m6.613s
user	0m0.000s
sys	0m0.001s


Tiago
