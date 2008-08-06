Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYHFVv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYHFVv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYHFVvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:51:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:59057 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYHFVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sd1MB5vKIcCZHsljUN15rWVUv7pCQqiXWKPExDhAEwA7fR26dpQ/n23iTE+L7/I3Fr
         M8tpHw9fQzVKys3xT8Zvap82fG3XCuUysIJFJe1tUh3j/ELyhe8F61zrtjzcLz9M+gYT
         Z2Pu0PRl6l9kMXq+z5+7B+D3YOC3EI9AiQ040=
Message-ID: <489A1CEF.4060302@gmail.com>
Date: Wed, 06 Aug 2008 23:51:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Simple UART driver help and TTY questions
References: <20080805163307.GJ6257@ovro.caltech.edu> <489A1364.4020809@gmail.com> <20080806214635.GM6257@ovro.caltech.edu>
In-Reply-To: <20080806214635.GM6257@ovro.caltech.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2008 11:46 PM, Ira Snyder wrote:
> On Wed, Aug 06, 2008 at 11:11:00PM +0200, Jiri Slaby wrote:
>> conOn 08/05/2008 06:33 PM, Ira Snyder wrote:
>>> static void tiny_config_port(struct uart_port *port, int flags)
>>> {
>>> 	FUNC_ENTER();
>>         if (flags & UART_CONFIG_TYPE)
>>                 port->type = PORT_16550A;
>>
>>> }
>> According to the straces, you get -EIO from ioctl and read which most 
>> likely means TTY_IO_ERROR bit set due to tiny_port->type = PORT_UNKNOWN 
>> (i.e. 0). Try the above.
> 
> Not quite, but it got me on the right track. I needed to set port->type
> before calling uart_add_one_port().

Ah,
.flags          = ASYNC_BOOT_AUTOCONF
I guess?

+ I'm sure you will need to set up more entries of your uart_port structure.
