Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYAXQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYAXQHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYAXQG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:06:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYAXQG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:06:56 -0500
Message-ID: <4798B793.8080909@redhat.com>
Date: Thu, 24 Jan 2008 11:06:43 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 3/4] firewire: enforce access order between generation
 and node ID
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <200711011453.35268.nickpiggin@yahoo.com.au> <4729A1BF.8010800@s5r6.in-berlin.de> <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de> <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> fw_device.node_id and fw_device.generation are accessed without mutexes.
> We have to ensure that all readers will get to see node_id updates
> before generation updates.
> 
> An earlier incarnation of this patch fixes an inability to recognize
> devices after "giving up on config rom",
> https://bugzilla.redhat.com/show_bug.cgi?id=429950
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Verified in concert with parts 1 and 2 as well as with 1, 2 and 4, to fix
'giving up on config rom' issues on multiple system and drive combinations
that were previously affected.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>



-- 
Jarod Wilson
jwilson@redhat.com

