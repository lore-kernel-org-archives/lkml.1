Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYDIJON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYDIJON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDIJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:13:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:38429 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYDIJN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TLOzDgBQz5rTxU4HMOZXLIMOtQfHpb7RStHFa9wWdfAuRPpIimn6Zsh/qBz6vZS27nSBYBYdZqVfPFAcco5sNlVuM467YNDujKcqdPrgXj0BP/+qN9vKzDWKNCYVvS2PR9JkD3mgQFCuju9HZYBfq6ihNMe6QP1KciaFenfg9XM=
Message-ID: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
Date: Wed, 9 Apr 2008 11:13:56 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: VM - a plenty of inactive memory
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

i got a weird problem with one of my servers. It's a Intel SR2500AL
with 32GB of RAM.
Looking at the memory usage of the system, something is going totally
wrong. The crucial numbers from /proc/meminfo are:

MemTotal: 33265916 kB
MemFree: 416168 kB
Inactive: 24630428 kB (24GB? whooaaa)

Another system with only 16GB, same amount of users and load, shows a
more normal behaviour:

MemTotal: 16619808 kB
MemFree: 6912676 kB
Inactive: 1774364 kB

Why does the 32GB-System have this plenty of inactive memory. Is there
a way to find out, what the kernel is holding in readiness (that's the
definition of inactive memory afaik)?

OS: SLES 10 SP1
Kernel : 2.6.16.27-0.9-bigsmp

Thanks in advance.

Andreas Grimm
