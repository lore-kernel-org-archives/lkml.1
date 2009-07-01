Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZGAS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZGAS2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZGAS2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:28:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZGAS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:28:38 -0400
Date: Wed, 1 Jul 2009 14:28:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, akpm@linux-foundation.org, earl_chew@agilent.com,
       nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v6)
Message-ID: <20090701182834.GC31414@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, one more time to fix the comments

This patcset provides improvements to the core_pattern infrastructure:

1) Make detection of recurseive core dumps more robust and accurate

2) Provide a sysctl to limit the number of parallel coredumps in flight when
using pipes

3) Allows for the kernel to wait for the completion of user space core dump
processing

Neil

