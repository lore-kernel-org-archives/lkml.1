Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYKDPD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYKDPD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYKDPDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:03:48 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:24798 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYKDPDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SYO/ooJEgjQzaysKvT2oYJkPsn+tAvLMAM+c2a5li0wEvdtK0I8poFACwoBQCvFD8N
         i1/CRAF5JctgZeDRgWHkLN0WhAGyF1izwaWR+xyV7uO49jp4L2P7eHG1fRsSUkykDYVM
         q0g3CthAKagu9subF38ULzmc7PO0+eo2fRKSE=
Message-ID: <cf70f0210811040703j116a54dap576fbaaffd1be2b7@mail.gmail.com>
Date: Tue, 4 Nov 2008 20:33:45 +0530
From: "Shivdas Gujare" <shivdas.tech@gmail.com>
To: beagleboard@googlegroups.com
Subject: measuring boottime ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all ,

I tried to find out another way to measure boottime of beagle board
(since I am not able to find a solution to
http://bugzilla.kernel.org/show_bug.cgi?id=10648)

I created a custom initrd.img , while creating rootfs, I added
following lines to /etc/init.d/rcS script,
"cat /proc/uptime".

I disabled all kernel debug messages and able to get console with
output of cat /proc/uptime as,
"1.07 0.38".

Does this mean, boottime is 1.07 sec or do I needs to follow another method?

Thanks for any help.

Regards,
Shivdas
