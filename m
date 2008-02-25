Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYBYV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYBYV3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYBYV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:29:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:57773 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYBYV30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LuCtfFz6oXR3ugKerAlMqp+c+saHqb04fIfpfp/g0ZgrCcYHvDkfwkj4ya28GDhcSOnWCPBPSFKE82hotIHhzMOt6v+AMCRT0ymYZIVGx6uWNPi0CWzfQHMbnAu+okOYEg2ghVQ7kZoQ2FFEeoS+1UFesxsZ+APMRJnRmykSsiE=
Message-ID: <6278d2220802251329x75b6d4c5lc3fab6fe6e75363f@mail.gmail.com>
Date: Mon, 25 Feb 2008 21:29:24 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [2.6.25-rc3] ACPI _PPC limiting processor speed...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My 2.2GHz [1] Thinkpad T61 is unable to get past 1.2GHz, seemingly
because of the _PPC ACPI objects [2].

Given that the _PPC object is different for both cores, is this more
of a BIOS bug or an ACPI interpreter problem? The problem was present
in 2.6.24-rc, 2.6.24 final and since.

BIOS is 7LETA9WW/2.09, so current - would any further information be
useful for debugging this problem, and would dumping the ACPI tables
be useful?

Thanks,
  Daniel

--- [1]

freq-table: table entry 0: 2201000 kHz, 0 index
freq-table: table entry 1: 2200000 kHz, 1 index
freq-table: table entry 2: 1600000 kHz, 2 index
freq-table: table entry 3: 1200000 kHz, 3 index
freq-table: table entry 4: 800000 kHz, 4 index

--- [2]

cpufreq-core: CPU 0: _PPC is 3 - frequency  limited
cpufreq-core: CPU 1: _PPC is 0 - frequency not limited
-- 
Daniel J Blueman
