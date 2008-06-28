Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYF1UCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYF1UCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 16:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYF1UB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 16:01:59 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:45977 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYF1UB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 16:01:58 -0400
Message-ID: <486698E4.4030905@keyaccess.nl>
Date: Sat, 28 Jun 2008 22:02:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Jiri Slaby <jirislaby@gmail.com>, David Howells <dhowells@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [patch 11/28] PNP: whitespace/coding style fixes
References: <20080627225651.663174474@ldl.fc.hp.com>	 <20080627225800.517972351@ldl.fc.hp.com> <1214682983.8758.66.camel@localhost>
In-Reply-To: <1214682983.8758.66.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-06-08 21:56, Joe Perches wrote:
> On Fri, 2008-06-27 at 16:57 -0600, Bjorn Helgaas wrote:
>> Index: work10/drivers/pnp/interface.c
>> ===================================================================
>> --- work10.orig/drivers/pnp/interface.c	2008-05-09 14:42:25.000000000 -0600
>> +++ work10/drivers/pnp/interface.c	2008-05-09 14:45:57.000000000 -0600
>> @@ -216,12 +216,12 @@ static ssize_t pnp_show_options(struct d
>>  				struct device_attribute *attr, char *buf)
>>  {
>>  	struct pnp_dev *dev = to_pnp_dev(dmdev);
>> +	pnp_info_buffer_t *buffer;
>>  	struct pnp_option *independent = dev->independent;
>>  	struct pnp_option *dependent = dev->dependent;
>>  	int ret, dep = 1;
>>  
>> -	pnp_info_buffer_t *buffer = (pnp_info_buffer_t *)
>> -	    pnp_alloc(sizeof(pnp_info_buffer_t));
>> +	buffer = pnp_alloc(sizeof(pnp_info_buffer_t));
>>  	if (!buffer)
>>  		return -ENOMEM;
> 
> Wouldn't it be nicer without the unnecessary cast?
> 
> 	pnp_info_buffer_t *buffer = pnp_alloc(sizeof(*buffer));

He deleted the cast (the sizeof(type) versus sizeof(var) thing is mostly 
personal preference).

Rene.
