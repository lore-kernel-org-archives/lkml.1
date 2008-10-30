Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYJ3Edo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYJ3Edo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYJ3Edf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:33:35 -0400
Received: from senator.holtmann.net ([87.106.208.187]:58736 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYJ3Ede (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:33:34 -0400
Cc: "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Message-Id: <0A2A3474-50D5-423A-8E03-C19FE4BABBB5@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1225329299.5970.67.camel@nga.site>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: net: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Thu, 30 Oct 2008 05:33:29 +0100
References: <1225329299.5970.67.camel@nga.site>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
>
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
>
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
>
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.

it would be nice if you modify your script to include a diffstat here :)

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: net: struct device - replace bus_id with dev_name(),  
> dev_set_name()
>
> CC: David S. Miller <davem@davemloft.net>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

the Bluetooth parts look fine to me.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

