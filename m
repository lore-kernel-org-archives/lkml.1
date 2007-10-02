Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXJBTZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXJBTZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXJBTZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:25:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXJBTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:25:31 -0400
Message-ID: <47029A32.7010803@zytor.com>
Date: Tue, 02 Oct 2007 12:21:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] mark read_crX() asm code as volatile
References: <470250E0.5090706@openvz.org> <20071002082856.3c478e66@laptopd505.fenrus.org>
In-Reply-To: <20071002082856.3c478e66@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 02 Oct 2007 18:08:32 +0400
> Kirill Korotaev <dev@openvz.org> wrote:
> 
>> Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from
>> gentoo) can generate incorrect code with read_crX()/write_crX()
>> functions mix up, due to cached results of read_crX().
>>
> 
> I'm not so sure volatile is the right answer, as compared to giving the
> asm more strict contraints....
> 
> asm volatile tends to mean something else than "the result has
> changed"....
> 

One of the aspect of volatility is "the result will change in ways you 
(gcc) just don't understand."

	-hpa
