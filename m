Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZJBOd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZJBOd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZJBOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZJBOd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:33:27 -0400
Message-ID: <4AC60EE3.4070708@redhat.com>
Date: Fri, 02 Oct 2009 10:32:03 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       alex.zeffertt@eu.citrix.com, Martin Wilck <Martin.Wilck@ts.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
References: <4AC47DED0200007800017743@vpn.id2.novell.com> <4AC5234C.5030409@citrix.com> <20091002012806.GB27478@andromeda.dapyr.net> <4AC5C7130200007800017A42@vpn.id2.novell.com>
In-Reply-To: <4AC5C7130200007800017A42@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 03:25 AM, Jan Beulich wrote:
>>>> Konrad Rzeszutek<konrad@darnok.org>  02.10.09 03:28>>>
>> The issue as I've come to understand is that the virt_to_phys on
>> memory below the 1MB does not work. Alex suggested another fix which
>> ioremap's the iBFT region, but I think this patch by Martin does the same job.
>>
>> Either way, it looks good to me.
>>
>> Signed-off-by: Konrad Rzeszutek Wilk<ketuzsezs@darnok.org>
>
> With both ofyou having signed off on it - who's going to push this to
> Linus? I'm specifically asking in case I'm expected to.

Not sure how that's supposed to work, but I'm cool with you doing it ;)
