Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZJSBEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZJSBEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 21:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZJSBED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 21:04:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:19534 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZJSBEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 21:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v/qn/xA+pDnNFSFOuCeR0SrbXEvN0FRTN2O/yyBezoRd5Oo+tsvhPwEUxawv3JKFwI
         xI3vrFyh2aNay+oKUnCJ/cHl/0l7Ydw8zdfN/lUUDuof91orZKmTix9BGmDWdN54eRHv
         /YKXKrXjTOBEqFYpJMPsxWDjXo/rusWhMLXaA=
MIME-Version: 1.0
In-Reply-To: <20091019000221.GA23405@kroah.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
	 <20091019000221.GA23405@kroah.com>
Date: Mon, 19 Oct 2009 04:04:04 +0300
Message-ID: <94a0d4530910181804g74543e4fp436aa36eaae0885@mail.gmail.com>
Subject: Re: [PATCH 1/7] usb: trivial cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 3:02 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 19, 2009 at 01:54:28AM +0300, Felipe Contreras wrote:
>> It seems 'min_t' was used before, and looks cleaner, plus white-space
>> stuff.
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> But this doesn't fix a kernel warning, does it?  If so, what one?

No, it's just cleanups I noticed while trying to fix the warning I
described here:
http://lkml.org/lkml/2009/10/18/126

-- 
Felipe Contreras
