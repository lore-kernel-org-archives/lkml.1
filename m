Return-Path: <linux-kernel-owner+w=401wt.eu-S1765256AbZDIUms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765256AbZDIUms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbZDIUmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:42:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36987 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759636AbZDIUma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:42:30 -0400
Message-ID: <49DE5DB0.3030209@garzik.org>
Date: Thu, 09 Apr 2009 16:42:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org> <49DE2905.3030102@rtr.ca>
In-Reply-To: <49DE2905.3030102@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> a single utility should be used to configure a SATA+SAS controller 
>> port.  Requiring use of hdparm when the port is in SATA mode, and sg_* 
>> when the port is in SAS mode, is a bit annoying.
> ..
> 
> That's why hdparm uses sg_* whenever possible already.

Does hdparm really call out to external applications sg_senddiag, 
sg_opcodes, sg_inq, sg_turs, etc.?

	Jeff



