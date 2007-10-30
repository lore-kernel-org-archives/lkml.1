Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXJ3Tcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXJ3Tcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbXJ3T1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:27:51 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:62707 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbXJ3T1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:27:50 -0400
Message-ID: <47278591.90305@freescale.com>
Date: Tue, 30 Oct 2007 14:27:13 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: checkpatch bug: space between left parenthesis and asterisk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running checkpatch.pl (dated 10/17), and it complains about this line:

crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));

the message I get is:

ERROR: need space before that '*' (ctx:BxW)
#721: FILE: arch/powerpc/sysdev/qe_lib/qe.c:527:
+       crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));
                             ^

so I add a space, and now I get this:

ERROR: no space after that open parenthesis '('
#721: FILE: arch/powerpc/sysdev/qe_lib/qe.c:527:
+       crc = __be32_to_cpu( * ((__be32 *) ((void *) firmware + calc_size)));

