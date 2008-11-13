Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYKMWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYKMWOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYKMWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:14:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:56973 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYKMWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=finakBB2yQn37UKD2YgR027aWkyUyzEyWALw8HvFmqdN67LaMbSjWI2it7XsovdVCC
         vwHzt2kdjOJpTAFuJYuLo797UKY/deFvBddH5+aW9iubeyD8Ytfjtpph/gEHiR7qJhjx
         KaaLSB1AOO48ptcOA6/Q8zuL4jmX30PcU50Io=
Message-ID: <491CA6AD.5050706@gmail.com>
Date: Thu, 13 Nov 2008 23:14:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: don't grab devices with no input
References: <Pine.LNX.4.44L0.0811131632150.3036-100000@iolanthe.rowland.org> <491CA495.7010007@gmail.com> <20081113222200.GD3810@one.firstfloor.org>
In-Reply-To: <20081113222200.GD3810@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2008 11:22 PM, Andi Kleen wrote:
> On Thu, Nov 13, 2008 at 11:05:09PM +0100, Jiri Slaby wrote:
>> On 11/13/2008 10:37 PM, Alan Stern wrote:
>>> Do you want to use usb_endpoint_is_int_in() instead?  It matches the 
>>> error message more closely.
>> Yes, good catch, thanks.
> Should I test it with that change or the original version?

The updated one, please.
