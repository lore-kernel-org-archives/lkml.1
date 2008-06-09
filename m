Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYFIKbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYFIKbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbYFIKa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:30:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:49406 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbYFIKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Gk08YvR5LMlMA2IiXwlgAWq+WeonLwRpYopNW8VVQzbM8oPfUIOi6RK3CQogN+0RY+
         7BH9+4uEHWBEHXMWNSdLxhSR+F7B2SuT819DamNATSNUSCfoomOk7nfjJwDOLITR5xE5
         mBcSOqukeOVvJCE3e5iXxn2ZwMucRhSQ5onus=
Message-ID: <484D061E.5000308@gmail.com>
Date: Mon, 09 Jun 2008 12:29:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <1210931362-18422-2-git-send-email-jirislaby@gmail.com> <1210931362-18422-3-git-send-email-jirislaby@gmail.com> <1210931362-18422-4-git-send-email-jirislaby@gmail.com> <1210931362-18422-5-git-send-email-jirislaby@gmail.com> <1210931362-18422-6-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0806041415130.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806041415130.10085@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 06/04/2008 02:16 PM, Jiri Kosina wrote:
> On Fri, 16 May 2008, Jiri Slaby wrote:
>> Move them from core code to a separate driver.
> is there a reason why this moves only the report descriptor 
> Logitech-specific quirks, but leaves the input mapping still in 
> hid-input-quirks.c and doesn't move it into ->input_mapping method too?

No, there is no strong reason, I just postponed it to the second round of 
changes. I wanted to hear comments first, so I only moved fully only apple 
driver (to present how the concept was thought). After things settle down, I'm 
going to move the rest of quirks including this one.
