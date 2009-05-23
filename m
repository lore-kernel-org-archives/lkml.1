Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZEWMpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZEWMpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZEWMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:45:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:16216 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEWMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ee2VGlRjrrt8Y80/8JMgb/g4PT4TdHltFatqZ9fRdJKCFLjg3vqxMGQQMshH0l8QK2
         Mkyjy+AFPMOP8LfeSSl13VBZxYSYbepaM+4oNB0catzOGwbriSOzvzd1p65Zho0MrxXW
         ZW9MBYLCZsLCL42EG9dj7HMOkKHIyElR6xns8=
MIME-Version: 1.0
In-Reply-To: <20090522145457.GC7234@tiehlicka.suse.cz>
References: <c384c5ea0905211759v11408a03o570980a34d02f0ff@mail.gmail.com>
	 <20090522145457.GC7234@tiehlicka.suse.cz>
Date: Sat, 23 May 2009 14:45:21 +0200
Message-ID: <c384c5ea0905230545l6bedf344haa2757e99a9b900a@mail.gmail.com>
Subject: Re: Rich man's version of AIO on Linux 2.6.x?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 22, 2009 at 4:54 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 22-05-09 02:59:53, Leon Woestenberg wrote:
>> On the state-of-art of asynchronous I/O in Linux. I understand we have
>> full support for AIO in the Linux 2.6.x kernel but I cannot find how
>> to use it from user space.
>>
>> I would like to exploit AIO in hardware and the device driver for it,
>> by keeping the hardware performing I/O at all times (no setup latency
>> between requests by allowing multiple
>> I/O requests to be queued in hardware). Note this is a character
>> device, not a filesystem.
>
> Check the libaio library (io_submit and friends)
>

Thanks, I checked the libaio library. It does not support the POSIX
interface, which I'ld like to use to keep things portable.

The http://www.bullopensource.org/posix/ library is more promising in
that regard but it doesn't seem maintained.

Regards,
-- 
Leon
