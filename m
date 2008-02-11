Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYBKRUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYBKRUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYBKRTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:19:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYBKRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:19:53 -0500
Message-ID: <47B083A0.4090900@redhat.com>
Date: Mon, 11 Feb 2008 12:19:28 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] firewire: fw-sbp2: don't add scsi_device twice
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.2ef253adcedcb9ea@s5r6.in-berlin.de>
In-Reply-To: <tkrat.2ef253adcedcb9ea@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> When a reconnect failed but re-login succeeded, __scsi_add_device was
> called again.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Was the spurious __scsi_add_device simply failing, or was it causing 
other problems as well? I can't remember if I've hit that or not. In 
either case, not calling it when we know we don't need to makes sense.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com

