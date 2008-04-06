Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYDFEDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYDFEDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 00:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYDFEDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 00:03:42 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:31841 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYDFEDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 00:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=v1YZeP66kUGlXt929Wgqdy0X0sIQy3r7NT0i9Ef1HctUfK4+E5NdGe6NNA+U6Cmpnr55upieF3om5OB8dqUF7m2CWwTmIKrpo9pzDdRVdrvalWyFAYK1eLhTEkIJstL2WBuhA9d3ho0Xmf6I1r9PAByIUApyOCPlASdvjxL0+ec=
Message-ID: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
Date: Sun, 6 Apr 2008 04:03:40 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: suspend issue
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I seem to have discovered something with echo mem > /sys/power/state.
I recompile the kernel and had forgotten to compile fglrx, when
performing a suspend without fglrx I was confronted with the dreaded
blank screen and a reboot. then as a test I compiled fglrx and loaded,
and to my amazement suspend reacted properly again.

-- 
Justin P. Mattock
