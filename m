Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZAZSLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZAZSLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZAZSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:10:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:63242 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZAZSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:10:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ol2kLmUygTBEMs7AJ8zslpCEmfgcRpCGA9nVsOLphoxHLkZ35Oj4PsgtdImGN0NzV8
         iLpwdUIkH2kWeBTkXMJnwKhpAopSOksh23oQOaYNEZ4899zgA4+DboccUD25xIlRWNPA
         WVFJDVe5Rhl/0uRtymM87YXY3rD5fieJiRB44=
MIME-Version: 1.0
In-Reply-To: <497DFB04.1040802@cs.helsinki.fi>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090126175115.GA29205@kroah.com> <497DFB04.1040802@cs.helsinki.fi>
Date: Mon, 26 Jan 2009 20:10:42 +0200
X-Google-Sender-Auth: 2b022ebe293927d8
Message-ID: <84144f020901261010h67958566lbd9ea240dc6d9ec@mail.gmail.com>
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in 
	wb35_probe()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 8:03 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Greg KH wrote:
>>
>> On Thu, Jan 22, 2009 at 12:06:33PM +0200, Pekka J Enberg wrote:
>>>
>>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>>
>>> If successful, the usb_control_msg() function returns the number of
>>> bytes transferred. Fix up wb35_probe() to only bail out if the function
>>> returns a negative number.
>>>
>>> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
>>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> I'm confused, should I apply this patch or not?
>
> Yes, you should. What's confusing you here?

Oh, looking at the thread, I see how you got confused. The patch
doesn't fix all of Sandro's problems but is an obvious improvement so
it should be merged.
