Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXIHSpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXIHSpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbXIHSoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:44:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:29784 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbXIHSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=OZjbOb2LrmoHG6mGVWEZJgDv/obOuzxLRMFDp3kBcFotCo40rJxG0Bw1ei7DGESfJoBtQjpb2gwdjNK4go/sFJ4nS4k8OfYmm5d/aYd1j7OE2kvxSwUMvUMiz1+TuV/uO8zauYE/t7N3iEuv49wh8q/7hm6c803/q0tvwmynJWw=
Date: Sat, 8 Sep 2007 20:44:38 +0200
From: Nicolas Capit <nicolas.capit@imag.fr>
To: linux-kernel@vger.kernel.org
Cc: pj@sgi.com, Simon Derr <Simon.Derr@bull.net>
Subject: cpuset trouble after hibernate
Message-ID: <20070908204438.3bf03d85@localhost.localdomain>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is my situation:
  - I mounted the pseudo cpuset filesystem into /dev/cpuset
  - I created a cpuset named oar with my 2 cpus

cat /dev/cpuset/oar/cpus 
0-1

  - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
  - After reboot:

cat /dev/cpuset/oar/cpus 
0

Why did I lost a cpu?
Is this a normal behavior???

Thank you for your attention,
Nicolas Capit


Note on my system:
  - laptop HP dv2000 with a Turion64x2
  - kernel : Linux 2.6.22-1-686 #1 SMP Sun Jul 29 14:37:42 UTC
2007 i686 GNU/Linux
