Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbXLZLv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbXLZLv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXLZLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:51:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:57568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXLZLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VBPFi26EkMB0RuYQEZ9cP5sD1I2uoQ14v2iSWh8MBXWF8yky7RfSXKzTR6YxFfjG289E7wwn4ZPqe++IirVm0M2tcmR266BEGuICygIXvEqygvv6O/vdm3tN/zUPV3jNtHyR+al7Nm2kwVKjwTOlfnHS0FJljeJM4modpfsyWYg=
Message-ID: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com>
Date: Wed, 26 Dec 2007 13:51:18 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: read-ahead in NFS server
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
my NFS server seems not to utilize the read-ahead feature, my exported
dir is located on ext3 fs over sata disk. the sata controller can
issue commands up to 1MB, also I modified the read ahead under the sys
to 1MB. but when the client do reads in 32KB chunks (rsize), I can see
in the server side that all IOs are ~32KB. my kernel version is
2.6.22.7.
according to the nfsd code, the NFS server should utilize the
read-ahead feature, but what should I do
to make it work?


saeed
