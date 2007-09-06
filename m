Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXIFMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXIFMew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXIFMen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:34:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXIFMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:34:42 -0400
Message-ID: <46DFF3BC.6060104@zytor.com>
Date: Thu, 06 Sep 2007 13:34:04 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: James Pearson <james-p@moving-picture.com>,
       Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com> <200605242029.k4OKTn9C031700@terminus.zytor.com> <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com> <46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com> <h87in5sgal.fsf@pepelac.englab.brq.redhat.com> <46DE6196.3050605@zytor.com> <46DEE0C9.1000402@moving-picture.com> <Pine.LNX.4.64.0709061429331.25942@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709061429331.25942@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Sep 5 2007 18:00, James Pearson wrote:
>> OK, here is the patch (without the long line) against 2.6.23-rc5 - what else
>> needs to be done to get it committed?
> 
> Someone has to point out CodingStyle, so I'll ruin everyone's day now :)
> 
>> +static ssize_t environ_read(struct file * file, char __user * buf,
>                                             ^                   ^
> be gone these spaces.
> 
>> +       while (count > 0) {
>> +               int this_len, retval;
>> +
>> +               this_len = mm->env_end - (mm->env_start + src);
>> +
>> +               if (this_len <= 0) {
>> +                       break;
>> +               }
> 
> Be gone, braces.
> 

Right, also please use use checkpatch.pl.

	-hpa

