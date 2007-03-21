Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXCUW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXCUW74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXCUW74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:59:56 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:41824 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753027AbXCUW7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:59:53 -0400
Message-ID: <4601B89E.3060605@cosmosbay.com>
Date: Wed, 21 Mar 2007 23:58:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>, David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: [RFC] : Is /proc/kcore still usefull and/or maintained ?
References: <200703211840.53242.maximlevitsky@gmail.com> <20070321222106.GF6057@elf.ucw.cz> <200703212339.02972.rjw@sisk.pl>
In-Reply-To: <200703212339.02972.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 21 Mar 2007 23:58:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

On i386 , 2.6.20 / 2.6.21-rc4 :

# gdb vmlinux /proc/kcore
error
# file /proc/kcore
error


Apparently we can not llseek() anymore on this file (returns -EINVAL)

On x86_64 2.6.20 it's working

# file /proc/kcore
/proc/kcore: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style


On i386 2.6.14 it's working too.

Eric
