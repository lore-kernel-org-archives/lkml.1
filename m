Return-Path: <linux-kernel-owner+w=401wt.eu-S1762405AbYA3RBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405AbYA3RBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYA3RBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:01:02 -0500
Received: from rtr.ca ([76.10.145.34]:3361 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYA3RA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:00:59 -0500
Message-ID: <47A0AD4A.20109@rtr.ca>
Date: Wed, 30 Jan 2008 12:00:58 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: ltuikov@yahoo.com, linux-arch@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: DMA mapping on SCSI device?
References: <896139.88121.qm@web31812.mail.mud.yahoo.com> <479FDA52.8050204@shaw.ca> <47A0AC33.1060504@rtr.ca>
In-Reply-To: <47A0AC33.1060504@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> ..
> Commands which were not ADMA compatible (eg. MODE_SENSE, 
> TEST_UNIT_READY, ..)
> were simply handled with PIO (in the driver) rather than any form of DMA,
> which is okay because those commands are relatively infrequent.
..

A slight correction there:  TEST_UNIT_READY was fine in ADMA mode as well.

Cheers
