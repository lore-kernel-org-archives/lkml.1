Return-Path: <linux-kernel-owner+w=401wt.eu-S965898AbXC2CCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965898AbXC2CCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 22:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965896AbXC2CCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 22:02:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49559 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965884AbXC2CCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 22:02:16 -0400
Message-ID: <460B1E24.3080502@pobox.com>
Date: Wed, 28 Mar 2007 22:02:12 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 1/3] libata: check for AN support
References: <20070328230108.597741522@intel.com> <20070328164443.9fc8b924.kristen.c.accardi@intel.com> <460B1C06.6040808@gmail.com>
In-Reply-To: <460B1C06.6040808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Kristen Carlson Accardi wrote:
>> Check to see if an ATAPI device supports Asynchronous Notification.
>> If so, enable it.
> 
> As supporting AN needs host interrupt handler change.  I think we need 
> host-supports-AN flag; otherwise, we might end up with screaming 
> interrupts in the worst case.

Quite so.  Lacking a host flag, we need to know how each and every 
controller behaves when AN is activated (and supported by the device). 
I'm willing to bet some of the first-gen SATA controllers' ASIC state 
machines croak when AN is activated.

	Jeff



