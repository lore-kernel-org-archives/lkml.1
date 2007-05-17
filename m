Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbXEQAEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbXEQAEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXEQAD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:03:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbXEQAD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:03:56 -0400
Date: Wed, 16 May 2007 20:03:38 -0400
From: Dave Jones <davej@redhat.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517000338.GC23751@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
	jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
References: <20070516235050.9B4237B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516235050.9B4237B409F@zog.reactivated.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:50:50AM +0100, Daniel Drake wrote:
 > powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
 > on SMP it requires the acpi-processor driver. Kconfig should be updated
 > accordingly to avoid the issues that users are running into.
 > 
 > http://bugzilla.kernel.org/show_bug.cgi?id=8075
 > https://bugs.gentoo.org/show_bug.cgi?id=178585

looks ok to me, but I'd like someone who has been seeing problems
to confirm this works first.

	Dave

-- 
http://www.codemonkey.org.uk
