Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZGBW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZGBW5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZGBW5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:57:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51522 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbZGBW5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:57:25 -0400
Date: Thu, 2 Jul 2009 18:57:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com, andi@firstfloor.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       nhorman@tuxdriver.com
Subject: Re: [PATCH 0/3] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v7)
Message-ID: <20090702225714.GA11447@hmsreliant.think-freely.org>
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


Patch V7, adjusting wait loop for signal handling.


This patcset provides improvements to the core_pattern infrastructure:

1) Make detection of recurseive core dumps more robust and accurate

2) Provide a sysctl to limit the number of parallel coredumps in flight when
using pipes

3) Allows for the kernel to wait for the completion of user space core dump
processing

Neil

