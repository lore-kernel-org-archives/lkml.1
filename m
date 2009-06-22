Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZFVMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZFVMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZFVMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:34:27 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35040 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZFVMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=axfJGKUZ0dC6useIq4xx2gQhxuIc+RtU64zvl3y9QL/dHe0h4NeeMf441yZzVP2TKC
         wJd76HuE4MrCwXfw9q/rmPcCN7MwNgBkZfYtxvDmFtZEDAtZJpLsilVJIRd2nORI+W5d
         mMqi3m260KjkO2AeN0AIe+p6OT8kqbDN/16nw=
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kyungmin.park\@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
References: <E4D3F24EA6C9E54F817833EAE0D912AC0228288428@bssrvexch01.BS.local>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 22 Jun 2009 14:33:50 +0200
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC0228288428@bssrvexch01.BS.local> (Marek Szyprowski's message of "Mon\, 22 Jun 2009 14\:04\:46 +0200")
Message-ID: <87iqio5txt.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Marek" == Marek Szyprowski <m.szyprowski@samsung.com> writes:

 Marek> Hello,

 Marek> I would like to ask if someone has successfully used g_serial
 Marek> USB gadget driver with kernel 2.6.29 or 2.6.30? I'm developing
 Marek> a low level hardware driver for USB gadgets on ARM S3C6410
 Marek> platform. This driver is working quite fine (I've used it a
 Marek> lot with g_ether CDC/RNDIS ethernet gadget driver). During my
 Marek> development I've found the following bug in g_serial driver:

You are aware that Ben Dooks has written an UDC driver for the OTG
controller on the s3c6410 which is now in mainline, right?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5b7d70c6dbf2db786395cbd21750a1a4ce222f84

I've used the g_serial driver on 2.6.29 without problems (not on
s3c6410 though).

-- 
Bye, Peter Korsgaard
