Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZKAXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZKAXBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZKAXBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:01:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZKAXBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:01:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=l2pydGbKQ0rPmEAuBYVgYWj64vHLfihexHllAIHH5+MRQb7xxamPhnJQsBUNEz2Eu
	MnLJX1dHgSe7veSX1cE+Q==
MIME-Version: 1.0
In-Reply-To: <20091101221345.GA16926@elf.ucw.cz>
References: <20091101221345.GA16926@elf.ucw.cz>
Date: Sun, 1 Nov 2009 15:01:19 -0800
Message-ID: <a55d774e0911011501x6abdb6a2p117f7038a4fa80cf@mail.gmail.com>
Subject: Re: [3/3,ARM] msm: add minimal board file for HTC Dream device
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 2:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> On Thu 2009-06-18 00:31:15, Brian Swetland wrote:
>> This is just enough to get the device booting and serial console
>> working.  Sufficient for debugging further MSM7k/Dream Support.
>> This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
>> are all the same hardware, known as "trout" to the ARM machine
>> database).
>>
>> Signed-off-by: Brian Swetland <swetland@google.com>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
>> Reviewed-by: GeunSik Lim <geunsik.lim@samsung.com>
>
> I'm trying to get this series to work -- i.e. get dream boot up-to
> serial console.
>
> I tried applying series on 2.6.29, and it failed compilation.
>
> On 2.6.30 and 2.6.32-rc, I get "Uncompressing linux..." feedback on
> serial, but that's it. Do you still remember what kernel version these
> should be applied to? .config would be helpful, too...

Pretty sure it's something later than .29

Does enabling DEBUG_LL help?  If something's dying before the serial
port is registered, you might never see any console chatter.

Also, I believe you'll want to pass console=ttyMSM2,115200n8 on the
kernel commandline  (-c parameter to fastboot or mkbootimg).

Brian
