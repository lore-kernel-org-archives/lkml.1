Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbXBES3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbXBES3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933289AbXBES3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:29:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:29475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbXBES3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Us1oOaw5iG1AKCGfYmLRDSgtWkg4PbHMA/vCybQQTNrGxt7r640C5VPNFSsuLx0Xwd0aiEKChWcGjrYSaLex69EJ+J8aX7CP7mBQSOYHoxkEPO1jT3uxR+s1WfBiQNil04HxOe6GH3xb1nuUEKiZQfD7L6Wc8dg1MsQzdxhSd4k=
Message-ID: <767314830702051029g2df96872kd0c35590fdb18f0b@mail.gmail.com>
Date: Mon, 5 Feb 2007 13:29:21 -0500
From: "Keenan Pepper" <keenanpepper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic works perfectly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu wrote:
> From the dmesg, I found a problem NOT relative to the PATA driver.
> I would like to know if cpu freq driver works? If not, please enter a
> acpi bug on bugzilla.kernel.org.

The acpi-cpufreq driver does work, but there are some other
ACPI-related problems. Most importantly for me, S3 sleep does not
work, and although S1 sleep works, the Fn key combinations stop
working afterwards. Should I file a bug about this?

Keenan
