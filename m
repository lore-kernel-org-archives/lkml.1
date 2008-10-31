Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYJaBXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYJaBXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYJaBWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:22:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:54956 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYJaBWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bBcaq/U8moLebaHZCEuxUsDlP32LNozijf0R8xh2N1Tfdi9wxRcYDnoEPwR6iDoixE
         xunQXQy6wDQ7D7cySOXp3+KQDA/r5j5axaWoYvj80zqiReHzkAh1jj3ZZJAeoAdiuuhv
         f6JK0GJYBX/Ctcondq1F55h5hUff6mYW6UxWY=
Message-ID: <a8e1da0810301822k3402e753m482d98f4530419a0@mail.gmail.com>
Date: Fri, 31 Oct 2008 09:22:52 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.26] OOPS in elv_next_request
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081030142550.GB11214@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027090426.GN8318@vanheusden.com>
	 <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
	 <20081030142550.GB11214@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:25 PM, Folkert van Heusden
<folkert@vanheusden.com> wrote:
>> > While running my http://vanheusden.com/pyk/ script (which randomly
>> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
>> > kernel on a Celeron 400 (Mendocino):
>> >
>> > [ 4768.664021] Floppy drive(s): fd0 is 1.44M
> ...
>> > [ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
>> > [ 4769.658313] Floppy drive(s): fd0 is 1.44M
>> > [ 4789.656060] no cont in shutdown!
>>
>> Hi, could you try the attached test patch?  sorry for using attachment
>> as there's some problem for my mail client to reply.
>
> As your patch is based on 2.6.27 I compiled the 2.6.27 kernel with it. But
> something odd is going on: when 2.6.27 boots, right after the initrd loading
> the screen-resolution gets changed or so, so that most text is no longer
> visible. Also the system seems to halt. Unfortunately too early for
> netconsole to emit the errors.

Yes, the patch is based on 2.6.27, but it can be applied to 2.6.26
without problem.

Could you try it with 2.6.26 again?

BTW, for 2.6.27, did you set vga=normal or other things?

-- 
Regards
dave
