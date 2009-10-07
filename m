Return-Path: <linux-kernel-owner+w=401wt.eu-S933736AbZJGPex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbZJGPex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbZJGPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:34:52 -0400
Received: from omr13.networksolutionsemail.com ([205.178.146.63]:33982 "EHLO
	omr13.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759270AbZJGPew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:34:52 -0400
X-Greylist: delayed 1677 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 11:34:52 EDT
Message-Id: <61241B44-32BD-4708-954F-AEE7560382DE@kayser.net>
From: Donald Kayser <linux@kayser.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: ppc_md.SMI replacement for 2.6
Date: Wed, 7 Oct 2009 10:06:05 -0500
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have ported the 2.6 kernel to an embedded PPC target (old stuff). I  
have managed to figure everything out, but can't find any replacement  
for a SMI handler. The original 2.4 version for this target has a bit  
of code ppc_md.SMI == SmiFuncHandler; I have not been able to find in  
the current source anything like this. I am not certain that I need to  
provide a handler at all, but the original developers saw some reason  
for including it. The particular handler does not do anything more  
than cancel a watchdog listener for this specific target. I have been  
living without the handler, but would like to find any kind of  
replacement if it is supported.

Thanks,
Donald Kayser
linux@kayser.net
