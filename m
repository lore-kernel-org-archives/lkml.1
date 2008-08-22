Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYHVRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYHVRSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYHVRRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:17:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbYHVRRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:17:54 -0400
Message-ID: <48AEF482.2060709@linux-foundation.org>
Date: Fri, 22 Aug 2008 12:16:50 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Skip memory holes in FLATMEM when reading	/proc/pagetypeinfo
 (resend)
References: <20080821132804.GA6206@csn.ul.ie> <1219421954.20559.73.camel@nimitz>
In-Reply-To: <1219421954.20559.73.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VMEMMAP code can also be instead of flatmem with holes. Just put the
memmap into real memory and make the populate function do nothing.
