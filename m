Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYB0Jz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYB0Jz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 04:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYB0JzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 04:55:14 -0500
Received: from senator.holtmann.net ([87.106.208.187]:49761 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYB0JzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:55:13 -0500
Cc: tglx@linutronix.de, kelk1@comcast.net, dwmw2@infradead.org,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, mingo@elte.hu
Message-Id: <C1D6688B-49F8-4ED1-B4F6-07F21243237F@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080226.174315.112638342.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
Date: Wed, 27 Feb 2008 10:55:07 +0100
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net> <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de> <20080226.174315.112638342.davem@davemloft.net>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 26 Feb 2008 09:28:13 +0100 (CET)
>
>> Delete a possibly armed timer before kfree'ing the connection object.
>>
>> Solves: http://lkml.org/lkml/2008/2/15/514
>>
>> Reported-by:Quel Qun <kelk1@comcast.net>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> I'll apply this, thanks Thomas.

can you please wait for a confirmation from Quel that this fixes it.  
My ACK is based on that he confirms that it fixes it for sure.

Regards

Marcel

