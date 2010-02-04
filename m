Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0BDF0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:26:34 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53885 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0BDF0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sK0HpRDSOcJ8koq5QFFV7VEqU8ULbWPcfxOTCQXv+jf2faUAPvkN9ktZzDfe7v3rkc
         jXS1hJgzyXifdpkXTWu2q3RZM0WVK4GhjqtRVxHCs7uqjpzDLQBJRZa0Fc5kognmOMfP
         gYJ10JwOXAAZvidtR19jPE+AvP2RzIi/54EtQ=
Message-ID: <4B6A5A81.2030207@gmail.com>
Date: Thu, 04 Feb 2010 07:26:25 +0200
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with set_memory_rw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, this is my first post in a mailing list, so excuse me if 
something wrong...
I'm new in kernel and try to do some manipulation with memory pages.
For manipulating memory page attributes i used set_memory_rw(),
but function returning 0 and i can't continue writing to memory,
because page, that i want to change, is read only by default.
This is part of my code:


long unsigned addr;

addr = 0x0509940;              //this is addres in memory, that i  want 
to overwrite (read only, for default)

set_memory_rw(addr, 1);    //try to set rw permission on this addres for 
one memory page.


So, function return zero, this is error, as i can understand. If i try 
to write by this address - kernel write in log error messages, such as 
"Unable to handle kernel request at address 0x0509940".
This is kernel bug or something wrong in my code?

Thank for any help.


Best regards,
Oleg.


