Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXLQJkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXLQJkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 04:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762985AbXLQJjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 04:39:51 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:28852 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085AbXLQJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 04:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CykN8nuwbF8Aa1RQX1zSTiCQ1ngCqNoItQT3grj0cHOLkprNhWnpjxz6lc6cnZJJRO0S3knkx1xtluq43gmtMi+XGTeoeL72cp/VTXIL5p/4N58QD9C6c69zngBKurbclUolibKKsh0fHd3XE07GtPUbr7MAuPJ6COT/uiNdTlE=
Message-ID: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
Date: Mon, 17 Dec 2007 11:39:47 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: INITIO scsi driver fails to work properly
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have got an INITIO 9100 UW SCSI Controller with an IBM
IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
Currently i have SUSE 10.1 (Kernel 2.6.16).

I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
driver
gets loaded during the installation process, yast reports that no hard
disk is found. I believe that this isnt a bug in suse's yast but a
problem
in the initio scsi driver because i also tried to install Fedora 8
(kernel 2.6.23) with the same problem.
I have seen the relevant thread "Conflict when loading initio driver"
and i suppose that the initio driver isnt fixed yet.
I can help testing the new patches in the initio driver if someone is
interested.
