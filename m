Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0CJIrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:47:55 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:54927 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0CJIrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:47:52 -0500
Message-ID: <4B975CB4.4000804@davidnewall.com>
Date: Wed, 10 Mar 2010 19:17:48 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
References: <460422.78917.qm@web7603.mail.in.yahoo.com>
In-Reply-To: <460422.78917.qm@web7603.mail.in.yahoo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Srinivas Nayak,

I don't suppose you're writing to a network mounted disk, with the 
network device's clock about half a second behind your test machine?  
Otherwise -- and I'm just guessing here, and will leave it to you to 
UTSL -- this could be explained by use of two different algorithms for 
converting a higher-resolution time source to the one-second 
resolution.  A truncation algorithm versus a rounding algorithm could 
produce the result you demonstrate.

Regards,

David
