Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBKRdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBKRdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbYBKRdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:33:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYBKRdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:33:10 -0500
Message-ID: <47B086BF.4000702@redhat.com>
Date: Mon, 11 Feb 2008 12:32:47 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] firewire: fw-sbp2: logout and login after failed
 reconnect
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.4988439f2c8906f5@s5r6.in-berlin.de>
In-Reply-To: <tkrat.4988439f2c8906f5@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> If fw-sbp2 was too late with requesting the reconnect, the target would
> reject this.  In this case, log out before attempting the reconnect.
> Else several firmwares will deny the re-login because they somehow
> didn't invalidate the old login.
> 
> Also, don't retry reconnects in this situation.  The retries won't
> succeed either.
> 
> These changes improve chances for successful re-login and shorten the
> period during which the logical unit is inaccessible.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Good stuff, easy to see how these will help our chances.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com

