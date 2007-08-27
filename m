Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbXH0I35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbXH0I35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXH0I3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:29:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:50538 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXH0I3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I0zgiDqhF3r7VeSEA0WbY4ZBOOL2JkuHiGJvrFg5KE1+fK8V+gGDFtKZR5pmm3Z4HaMJcLeQsxCL9qAWWwjZ/jDNdbeBVTdqrf1NclgA9nItKqB5CAAGMsZtQEyJwS1Gp83jQ3zMsmF6PDA0fLG1Ic1wC2xCrsEJvuS5+uUMQ/c=
Message-ID: <21d7e9970708270129u2a619b8dx79fbdaddc55fa16f@mail.gmail.com>
Date: Mon, 27 Aug 2007 18:29:48 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: resume failing on ATA controller
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got an HP 2510p with a 965 mobile chipset and ICH8, lspci is at

http://people.freedesktop.org/~airlied/hp2510p/hp-lspci-vv.txt

Resume is failing on the hard disk resume by the looks of it (no video
to prove it..) but I've rmmod nearly everything and my network
interface comes back and I can ping it but anything that tries to
access the disk looks stuck...

I also know someone running the same laptop using drivers/ide drivers
whose suspend/resume works properly....

I'm running the latest Fedora rawhide kernel based on -rc3-git7

http://people.freedesktop.org/~airlied/hp2510p/ata_dmesg.txt

Dave.
