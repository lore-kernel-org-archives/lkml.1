Return-Path: <linux-kernel-owner+w=401wt.eu-S937196AbYCSXyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937196AbYCSXyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYCSW1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:27:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941150AbYCSW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bBJKicoXKbf52ChVZTKLkcj3Xl0nEF6OW27enMVmpwD8WIsIIWalTn8sFizKBay0S4pUgEYDNtY1hTxQAL6M6CKfD10Le5LvYEc1DtmzxKQ+d3KnK0PmVVJ2PZQv/cvoDZrW2DpUBehnRREiJLpBPp6M6rY/hqIQ/dGOA2QlraY=
Message-ID: <47E19361.1010407@gmail.com>
Date: Wed, 19 Mar 2008 23:27:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Rick Brown <rick.brown.3@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: preempt_disable() question
References: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
In-Reply-To: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2008 03:14 AM, Rick Brown wrote:
> Hi,
> 
> I've asked this on kernel newbies before, but not enough responses.
> 
> Does preempt_disable() disable preemption on all the processors, or
> just the local processor?

AFAIU preempt_disable increments preempt count of the current task, so that 
nobody will take the cpu which it is executing on (scheduler doesn't allow that) 
while the task is running until preempt count lowers to 0. How do you mean the 
"disabling preemption on local processor", how/why would you want to disable 
preemption of task potentially running on the other one?
