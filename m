Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZDILNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZDILNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZDILNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:13:11 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:39888 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZDILNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KmeMZmaCEu/E+4erg60BJ5qLA45P2+6ik0Jpsb9Q3BhkGXIH3I2JOC5D96sr1zQChd
         RHrHVRb3Fr4dyPWXF/HVF+pXaqCwP2/22IVHqgmG15febCznuT9wpO5vS6Dwxp8PfyNM
         EJPZkf5eSexhXpCOXK8V887tP4ydKqsfRIX+I=
Message-ID: <49DDD83F.507@tuffmail.co.uk>
Date: Thu, 09 Apr 2009 12:13:03 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Regression: First hibernation attempt fails
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
wonder if it rings any bells?

On my laptop (EEE 4G), the first attempt at hibernation fails. 
Subsequent attempts succeed.

If I use s2disk as normal, I see "snapshotting system", then before it
gets to write out the image, it aborts and switches back to X.   I can't
see any error message, even if I check the log with "dmesg".

If I use "echo disk > /sys/power/state", echo reports the error "Cannot
allocate memory".

This only happens if I've logged in to X first.  In fact, I narrowed it
down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
then it doesn't happen.

Alan
