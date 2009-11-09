Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZKIMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZKIMwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZKIMw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:52:29 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39474 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbZKIMw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:52:29 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2009 07:52:29 EST
Message-ID: <bdb0f53eaa2c42735b3a575b2dfaa6c8d97131ae@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <1257632395.15927.524.camel@localhost>
References: <1257631753.15927.500.camel@localhost>
    <4AF5F1C7.8010101@simon.arlott.org.uk>
    <1257632395.15927.524.camel@localhost>
Date: Mon, 9 Nov 2009 12:42:07 -0000
Subject: Re: [PATCH 70/75] cxacru: declare MODULE_FIRMWARE
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Ben Hutchings" <ben@decadent.org.uk>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, November 7, 2009 22:19, Ben Hutchings wrote:
> On Sat, 2009-11-07 at 22:16 +0000, Simon Arlott wrote:
>> On 07/11/09 22:09, Ben Hutchings wrote:
>> > +++ b/drivers/usb/atm/cxacru.c
>> > +MODULE_FIRMWARE("cxacru-fw.bin");
>> > +MODULE_FIRMWARE("cxacru-bp.bin");
>>
>> It also optionally loads "cxacru-cf.bin".
>
> I saw that, but thought it better not to list optional files.

In that case, "cxacru-bp.bin" is optional as only certain versions
of the device require it.

Perhaps MODULE_FIRMWARE() should have an "optional" flag too, so
that all files can be listed?

-- 
Simon Arlott
