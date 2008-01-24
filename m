Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYAXQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYAXQFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYAXQFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:05:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbYAXQFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:05:32 -0500
Message-ID: <4798B747.1040408@redhat.com>
Date: Thu, 24 Jan 2008 11:05:27 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/4] firewire: fw-cdev: use device generation, not card
 generation
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <200711011453.35268.nickpiggin@yahoo.com.au> <4729A1BF.8010800@s5r6.in-berlin.de> <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de> <tkrat.8ff4f57f5db5f094@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8ff4f57f5db5f094@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> We have to use the fw_device.generation here, not the fw_card.generation,
> because the generation must never be newer than the node ID when we emit
> a transaction.  This cannot be guaranteed with fw_card.generation.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Verified in concert with parts 1 and 3 as well as with 1, 3 and 4, to fix
'giving up on config rom' issues on multiple system and drive combinations
that were previously affected.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com

