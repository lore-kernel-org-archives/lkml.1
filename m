Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZHNPFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZHNPFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbZHNPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:05:22 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34054 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbZHNPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:05:21 -0400
Date: Fri, 14 Aug 2009 11:05:15 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
Message-ID: <20090814150515.GB28790@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A857D2E.011D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 04:03:04PM +0100, Daniel J Blueman wrote:
> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
> [1] are false-positives, due to the overwriting of the static pointers
> [2]. Does this ring true with anyone else?

If these were real leaks you'd see errors during rmmod.  They should be
false positives.

-chris
