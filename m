Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZAWSjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZAWSjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZAWSjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:39:16 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:52078 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZAWSjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:39:15 -0500
Message-ID: <497A0ECE.6070508@walrond.org>
Date: Fri, 23 Jan 2009 18:39:10 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org> <497A034F.6060303@caviumnetworks.com> <497A06CE.9040901@walrond.org> <497A0884.3010408@caviumnetworks.com>
In-Reply-To: <497A0884.3010408@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> I did, I read every word of it.  I am sorry I was not specific enough 
> for you.  I really meant to ask:
>
> Do you have: CONFIG_SERIAL_8250_CONSOLE=y
>
"Machine A - ttyS0 works fine. Can get grub output, kernel boot and 
console via ttyS0 as I wanted."
 
So the whole chain works fine on this machine. This couldn't work 
without CONFIG_SERIAL_8250_CONSOLE or if I didn't know _how_ to do it.

But to prove it conclusively
 $ zcat /proc/config.gz | grep CONFIG_SERIAL_8250_CONSOLE 
CONFIG_SERIAL_8250_CONSOLE=y

Sorry for being snappy. Long day ;)

Andrew Walrond

