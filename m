Return-Path: <linux-kernel-owner+w=401wt.eu-S1422796AbXCGRwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796AbXCGRwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXCGRwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:52:19 -0500
Received: from terminus.zytor.com ([192.83.249.54]:45480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422796AbXCGRwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:52:10 -0500
Message-ID: <45EEFBA0.7030101@zytor.com>
Date: Wed, 07 Mar 2007 09:51:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Kosina <jikos@jikos.cz>, Jon Ringle <JRingle@vertical.com>,
       linux-kernel@vger.kernel.org
Subject: Re: tiny tty driver sample
References: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>	<Pine.LNX.4.64.0703071730190.10909@twin.jikos.cz> <20070307182318.28d95c95@lxorguk.ukuu.org.uk>
In-Reply-To: <20070307182318.28d95c95@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I guess something like
>>
>> 	tty_buffer_request_room(tty, data_size);
>> 	for (i = 0; i < data_size; ++i)
>> 		work += tty_insert_flip_char(tty, data[i], TTY_NORMAL);
>> 	if (work)
>> 		tty_flip_buffer_push(tty);
> 
> 
> Unless data_size can be very large and high speed then you can replace the
> lot with
> 
> 	if (tty_insert_flip_string(tty, data, data_size))
> 		tty_flip_buffer_push(tty);
> 

What does "very large and high speed" mean in this context?

	-hpa
