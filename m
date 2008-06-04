Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYFDKgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYFDKgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYFDKgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:36:24 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35478
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYFDKgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:36:23 -0400
Message-ID: <48466FAA.1070704@qumranet.com>
Date: Wed, 04 Jun 2008 13:34:18 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 pm-suspend/17334
References: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>	 <Pine.LNX.4.64.0806031350330.1716@twin.jikos.cz>	 <c4e36d110806030501g46363beev7126c8312aadd12e@mail.gmail.com>	 <Pine.LNX.4.64.0806031402450.6718@jikos.suse.cz>	 <48466349.1030907@qumranet.com> <c4e36d110806040257y698dbde4w4e717522478b74b8@mail.gmail.com>
In-Reply-To: <c4e36d110806040257y698dbde4w4e717522478b74b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> Oops is from my real-hardware T61 (host) running the kvm-qemu (guest)
> and was noticed after suspend.
> But everything seemed to work just fine - host&guest continued to
> operate normally after resume.
>   

Can you reproduce this, with and without the kvm modules loaded?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

