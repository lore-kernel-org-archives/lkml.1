Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYAPSZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYAPSZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYAPSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:25:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50493 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYAPSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:25:44 -0500
Date: Wed, 16 Jan 2008 18:24:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: EDD hangs
Message-ID: <20080116182419.2e5087bd@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a box here the kernel hangs on boot without "edd=off". Adding printfs
as hpa suggested shows that it correctly scans BIOS disk 1 (0x80) then on
disk 2 (PDC20263) it gets a version then hangs trying to read the MBR

Alan
