Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZKZVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZKZVjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZKZVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:39:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59351 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZKZVjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=XBgC5HtlFRnfRTUalkZK+9wVct+JcsLrrXpuomOC05oTP+vSlmqmuEogP0DJeevp0R
         tVZ3YXKkkA3RLqNdKATMA5V2ylmHV7hxTPIn9ywH1MmCJduruNFQ8CHNoJKu9Yqo+8KT
         iRwIi/1oNwEo5Ud4b1lVyQvqAHjOtfUp7XND0=
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <m3r5rpq818.fsf@intrepid.localdomain> <20091126052155.GD23244@core.coreip.homeip.net> <m31vjlw54x.fsf@intrepid.localdomain>
Message-Id: <1F6BE32B-13EE-4FB4-96AD-D4526F435777@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m31vjlw54x.fsf@intrepid.localdomain>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Date: Thu, 26 Nov 2009 13:39:09 -0800
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mario Limonciello <superm1@ubuntu.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2009, at 9:46 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
>
>> In what way the key interface is unsufficient for delivering button
>> events?
>
> At present: 128 different keys only (RC5: one group).

Where did this limitation come from? We have more than 256 keycodes  
already _defined_ in the input core and we can add more if needed.


> One remote per
> device only.

Why would you want more? One physical device usually corresponds to a  
logical device. If you have 2 remotes create 2 devices.

> The protocol itself doesn't have the above limitations, but has  
> others,
> with are acceptable for key input.
> -- 
> Krzysztof Halasa

-- 
Dmitry

