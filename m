Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZLEGvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZLEGvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 01:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZLEGvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 01:51:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZLEGvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 01:51:48 -0500
Message-ID: <4B1A01BB.7010405@zytor.com>
Date: Fri, 04 Dec 2009 22:46:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] pps: low level IRQ timestamps recording.
References: <1259774329-29663-2-git-send-email-giometti@linux.it> <1259774329-29663-3-git-send-email-giometti@linux.it> <1259774329-29663-4-git-send-email-giometti@linux.it> <1259774329-29663-5-git-send-email-giometti@linux.it> <1259774329-29663-6-git-send-email-giometti@linux.it> <1259774329-29663-7-git-send-email-giometti@linux.it> <1259774329-29663-8-git-send-email-giometti@linux.it> <1259774329-29663-9-git-send-email-giometti@linux.it> <1259774329-29663-10-git-send-email-giometti@linux.it> <4B170204.4080604@zytor.com> <20091203120130.GD12943@gundam.enneenne.com>
In-Reply-To: <20091203120130.GD12943@gundam.enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 04:01 AM, Rodolfo Giometti wrote:
>
> I see, that's why I propose my patches to you: in order to have some
> feedbacks for better solutions. :)
>
> Can I add a IRQF_TIMESTAMP in order to ask to the system to record irq
> timestamps for particular irq lines? The problem is that I cannot set
> that flag at irq_register() time but I have to do it later... it can
> be a problem?
>

Shouldn't be an issue, I don't think.  Deregistration might be an 
(minor) issue in the case of shared IRQs -- just requires some care.

	-hpa
