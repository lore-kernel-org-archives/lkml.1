Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbZFOJtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbZFOJtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbZFOJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:48:55 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17534
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758652AbZFOJsy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:48:54 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z34a4jz98dRzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL9XXD-03-AU8-01
Date: Mon, 15 Jun 2009 11:48:48 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] amd-iommu: kdump bugfix and couple defensive
	cleanups
Message-ID: <20090615094848.GD5139@amd.com>
References: <20090612030341.GQ20823@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090612030341.GQ20823@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Jun 2009 09:48:48.0901 (UTC) FILETIME=[7B7A7B50:01C9ED9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 08:03:41PM -0700, Chris Wright wrote:
> The following patches fix a kdump issue and then fix some similar
> initialization issues that haven't proven to be problematic but make
> good sense anyway.

The patches look good but are based on 2.6.30. For 2.6.31-rc1 they must
be changed a bit because some functions implemented in these patches
were already merged for the suspen/resume support in amd-iommu driver.
I will adapt them for 2.6.31. Do you want to send these patches for
-stable inclusion?

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

