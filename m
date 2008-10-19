Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbYJSWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbYJSWJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYJSWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:09:31 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:44921 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYJSWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=P7sy3HL19kI08T3hbBoOHcN2L8SmQjzea1WobXAr692EvA/Dw+3kUzoZekxP5RaUsD
         2h9UM+RzgU3xkdHdVR3pSjXQuCOo9k5zIsCJm/fKC4qp0r5A959HdFH85EG6Yy4dN3Jj
         POiNZK3+QgV0yhiEsDihMeG50mA05D+qzwgr0=
Message-ID: <48FBB012.40605@gmail.com>
Date: Mon, 20 Oct 2008 00:09:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Noonan <steven@uplinklabs.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Sven Anders <anders@anduras.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: several messages
References: <1224425749-22652-1-git-send-email-jirislaby@gmail.com> <1224425749-22652-2-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0810192135010.27479@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0810192135010.27479@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina napsal(a):
> On Sun, 19 Oct 2008, Jiri Slaby wrote:
> 
>> +enum hid_type {
>> +	HID_TYPE_UNKNOWN = 0,
>> +	HID_TYPE_MOUSE,
>> +	HID_TYPE_KEYBOARD
>> +};
>> +
> 
> Do we really need the HID_TYPE_KEYBOARD at all? It's not used anywhere in 
> the code. I'd propose to add it when it is actually needed. I.e. have the 
> enum contain something like HID_TYPE_MOUSE HID_TYPE_OTHER for now, and add 
> whatever will become necessary in the future, what do you think?

I would use unknown rather than other, since on bluetooth mouse is unknown
not other, if you don't mind?

Or did you mean tristate unknown, mouse and other?

Thanks for review.
