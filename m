Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZGCKpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZGCKpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZGCKo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:44:57 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44296 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZGCKo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:44:57 -0400
Date: Fri, 3 Jul 2009 06:44:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v8)
Message-ID: <20090703104447.GA19371@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch V8, converting fatal_signal_pending to signal_pending


This patcset provides improvements to the core_pattern infrastructure:

1) Make detection of recurseive core dumps more robust and accurate

2) Provide a sysctl to limit the number of parallel coredumps in flight when
using pipes

3) Allows for the kernel to wait for the completion of user space core dump
processing

Neil


