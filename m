Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0CIAev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:34:51 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:43789 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0CIAes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:34:48 -0500
Message-ID: <4B959791.5010802@seas.upenn.edu>
Date: Mon, 08 Mar 2010 19:34:25 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: mickib1@gmail.com
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       rafi@seas.upenn.edu
Subject: Re: [PATCH 1/7] HID: N-trig MTM Driver fix and cleanup patch 1
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
In-Reply-To: <1268082827-2680-1-git-send-email-micki@n-trig.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a comment before I respond to your patches.

Clearly my knowledge of the workings of your devices is limited.  I have 
no special access to your documentation or developers and no idea where 
the company plans to go in the future.

With that said, what I have seen is a set of devices which mostly follow 
standard behavior and thus are simple to support with existing drivers. 
  The kernel driver as of 2.6.33 names the device and does a tiny bit of 
clean up for pen and single touch, but mostly leaves the handling of 
those to the hid core.

Even the multi-touch support only needs slight tweaking to account for 
the "fake fingers" sent out by the hardware and some other minor points.


While I appreciate that you've put a lot of effort into writing and 
testing an in house tool stack, that doesn't justify breaking 
compatibility unnecessarily.  I too have spent considerable effort for 
more than a year (with months of non-functioning hardware before that), 
and have quite a lot of established testing time.  I do not feel that my 
work and the communal effort to test and fix justifies inhibiting your 
work, but it should justify some consideration.

Furthermore I tried to contact your company repeatedly before I began my 
work, and several times since.  That you have put so much effort in 
development and testing in isolation was your choice not mine.



So, if there is information that you can put to good use but leads to 
compatibility issues with existing tools (like the evdev driver), lets 
discuss those.

If you are ready to release the user space source, I will happily lend a 
hand synchronizing the kernel and user space.

Rafi
