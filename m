Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285Ab0ADFwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0ADFwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0ADFwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:52:32 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:48881 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0ADFwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tbq5k+i1R+1XEuGr37gdTl17cg1oxkKtSYEZ5m1ejVMWhEKp7qzL5HIVpmQipNi0+V
         FDGbRsMceDtuK82dcNk4gkLlOmD1mbj1JaK2c8WEZPNOB421gBU9K1XfzUAwIIn08XN1
         n9yS4VTxtF8xcID1ed5YUEvvICfF2gQTKe5c4=
Message-ID: <4B41821B.3050705@gmail.com>
Date: Sun, 03 Jan 2010 23:52:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: Tejun Heo <tj@kernel.org>, petkovbb@gmail.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
References: <4A062702.8020404@kernel.org> <201001040115.o041FCEA025051@turbo.physics.adelaide.edu.au>
In-Reply-To: <201001040115.o041FCEA025051@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2010 07:15 PM, Jonathan Woithe wrote:
>>>> Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
>>>> ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
>>>> or there is more needed to bring ide-tape to the world of living?
>>>
>>> ... and I'm afraid we'll have to do some serious bugfixing since this
>>> driver is behaving really funny :). Stay tuned, I'm on it.
>>
>> Cool.
>
> Has there been any movement on this in recent months?  I gave 2.6.30 a whirl
> on the machine when that was released but it still gave major problems with
> the ide-tape driver.  Is 2.6.32 likely to be improved?  If so I'll make
> arrangements to test that version.
>
> Presently I'm stuck with 2.6.24.x on this system since ide-tape holds
> together enough on this version to work.  I really want to upgrade to a more
> recent kernel but obviously I can't until ide-tape is functional again.

You could also try using libata instead of IDE drivers and see if they 
work any better for you..
