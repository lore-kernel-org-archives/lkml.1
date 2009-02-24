Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZBXALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZBXALz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZBXALq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:11:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40269 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbZBXALp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:11:45 -0500
Message-ID: <49A33B3C.6000907@us.ibm.com>
Date: Mon, 23 Feb 2009 16:11:40 -0800
From: Mike Mason <mmlnx@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Disabling an interrupt in interrupt context
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a need to disable an LSI interrupt from within the context of the handler for that interrupt.  It appears that disable_irq_nosync() will do the trick.  Besides dropping interrupts, which I don't care about because the device is in an error state, what are the potential side effects of doing this?  As far as I can tell, this will not prevent the current in-flight handlers for that interrupt from finishing.

Thanks,
Mike Mason

