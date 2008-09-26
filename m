Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYIZCmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYIZCmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYIZCm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:42:27 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:16790 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYIZCm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:42:26 -0400
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Message-Id: <63AB39A5-5C5D-446A-A12E-AF4008B465AE@anirban.org>
From: Anirban Sinha <kernel@anirban.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080925164517.GA194@tv-sign.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: wait_event_interruptible_timeout
Date: Thu, 25 Sep 2008 19:42:22 -0700
References: <13c67e2c0809242105t77ca9a6k2faf1e85064967aa@mail.gmail.com> <20080925164517.GA194@tv-sign.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25-Sep-08, at 9:45 AM, Oleg Nesterov wrote:
>
>
> We can even add another wait_ helper which treats "timeout" as lvalue
> and updates it before return. I dunno.


I agree. I think adding a new wait_ helper is probably the cleanest  
way to go since any updates to the old helper might break the kernel  
at numerous other places. I am sending the patch in my next email.

Thanks for responding,

Ani
  
