Return-Path: <linux-kernel-owner+w=401wt.eu-S1764163AbYHFEtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764163AbYHFEtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYHFEs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:48:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48731 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYHFEs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:48:56 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5181603"
Message-ID: <48992D35.9020005@qualcomm.com>
Date: Tue, 05 Aug 2008 21:48:53 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>	 <48991B07.3050500@qualcomm.com>	 <b6a2187b0808052050h35e2786fwfbf1e1dd5c37d8cf@mail.gmail.com>	 <48992085.3050203@qualcomm.com> <b6a2187b0808052106l1c553df4lab4e9e9f29de356d@mail.gmail.com>
In-Reply-To: <b6a2187b0808052106l1c553df4lab4e9e9f29de356d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Wed, Aug 6, 2008 at 11:54 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> Are you running 32-bit kernel ?
> 
> Yes. But, does it matter?

It used to. 64-bit kernel used to handle maxcpus option as documented in the 
Documentation/cpu-hotplug.txt and 32-bit one was broken.
I just looked at the latest code and realized that both are now broken. They 
ignore cpu id > maxcpus instead of not-booting them.

I'll send a patch that fixes that tomorrow.

Max
