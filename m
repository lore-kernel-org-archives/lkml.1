Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZKQDTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZKQDTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZKQDTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:19:33 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50959 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbZKQDTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:19:31 -0500
Message-ID: <4B021646.5040102@garzik.org>
Date: Mon, 16 Nov 2009 22:19:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, sean.hefty@intel.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH]AHCI: disable sntf cap for ich8
References: <20091116015605.GA21717@sli10-desk.sh.intel.com>
In-Reply-To: <20091116015605.GA21717@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2009 08:56 PM, Shaohua Li wrote:
> I obseved there is a sata_async_notification() for every ahci interrupt. But the
> async notification does nothing (this is hard disk drive and no pmp). This cause
> cpu wastes some time on sntf register access.
>
> It appears ICH AHCI doesn't support SNotification register, but the controller
> reports it does. After quirking it, the async notification disappears.

Patch applied.


> PS. it appears all ICH don't support SNotification register from ICH manual, don't
> know if we need quirk all ICH. I don't have machines with all kinds of ICH.

You work for Intel -- you or somebody needs to research and figure this 
out...  This is an Intel vendor issue that only Intel can definitively 
resolve.

	Jeff


