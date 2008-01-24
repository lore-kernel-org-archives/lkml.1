Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYAXSJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYAXSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYAXSJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:09:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:22851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYAXSJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PYtTYxD5mbTKKgjm4k2mBLksebdC0kSYNP04PKSt4oBedU3/65HRVonaKKjxhRXYGhj0DBwkY6bxJn2zlw2E8/b0A+gwu7SyDcPSNaN8FFVyG2UA8sTGBYv9zSCGvGmN2r1j1fGsUDlt384mbgSt84KYHd9TW3aow71du5w+Wr8=
Message-ID: <df35dfeb0801241009p24bdc766o7467ba82c403f9dc@mail.gmail.com>
Date: Thu, 24 Jan 2008 10:09:27 -0800
From: "Yum Rayan" <yum.rayan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: sysctl table, s390 and xfs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With reference to 2.6.24-rc5, I see in <kernel/sysctl_check.c>

      3 #include "../arch/s390/appldata/appldata.h"
      4 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"

Can this be done any better?

Should we move these headers to the standard <include> folder? Protect
them with "#ifdef CONFIG_" ?

I have a x86 configuration and don't use XFS. Do I still need to carry
these source files around?
