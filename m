Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYJMITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYJMITS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYJMITJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:19:09 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50955 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbYJMITI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EyWC8IX4E2V6NePXOc5+eTpwyWq8wYBQGgPKnI/LKSMvDnqf6g0Ow58R+MFdiq2+/0
         Hf93Dt1ntDPAu3aAE2uDmAifp0OIVHty3n26i+293+pFZ5Da2qYCWP4FQ9Wdft4x0M+Z
         kGASOxbiayJKWgto3J2PY6ScwID0ynnpVM6uQ=
Message-ID: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
Date: Mon, 13 Oct 2008 10:19:05 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: section mismatch with a platform driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am working on a platform driver, and getting the following warning:

WARNING: vmlinux.o(.data+0x44bc4): Section mismatch: reference to
.init.text:my_probe_func (between 'my_platform_struct' and
'debug_level_variable')

If I understand correctly, it shouts about my probe function being
referenced from the data section:

static struct platform_driver my_platform_struct = {
	.probe		= my_probe,
	.remove		= my_remove,
	.suspend	= my_suspend,
	.resume		= my_resume,
	.driver		= {
		.name = DRIVER_NAME,
	},
};

Why is that a problem ? Should I do something different ? Isn't my
platform_driver struct completely standard ?

Thank You !
Pnesh
