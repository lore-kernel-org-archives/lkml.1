Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbYCZBmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbYCZBmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbYCZBjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:39:22 -0400
Received: from testure.choralone.org ([194.9.77.134]:56644 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbYCZBjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:39:21 -0400
Date: Tue, 25 Mar 2008 21:39:13 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
Message-ID: <20080326013913.GC6384@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	"J.C. Pizarro" <jcpiza@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 10:39:39PM +0100, J.C. Pizarro wrote:
 
 > How can i know what hw-caches use the processors?
 > The current kernel doesn't know well what hw-caches uses.
 > 
 > The good proposal is by example (the data below are not real):
 > * In old AMD Athlon64:
 > 
 > cache L1        : 64 KiB I + 64 KiB D, 64 B line, direct way, ...
 > cache L2        : 512 KiB I+D-shared, exclusive, 128 associative way, ...
 > cache L3        : none
 > 
 > * In Intel Core Duo:
 > processor       : 0
 > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
 > cache L2        : 2048 KiB Cores-shared, inclusive, 128 associative way, ...
 > cache L3        : none
 > 
 > processor       : 1
 > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
 > cache L2        : 2048 KiB cores-shared, inclusive, 128 associative way, ...
 > cache L3        : none
 > 
 > * In Quad:
 > processor       : 0
 > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
 > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
 > associative way, ...
 > cache L3        : none
 > ...
 > processor       : 3
 > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
 > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
 > associative way, ...
 > cache L3        : none

See x86info.  http://www.codemonkey.org.uk/projects/x86info/

	Dave

-- 
http://www.codemonkey.org.uk
