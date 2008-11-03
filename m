Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYKCPFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYKCPFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYKCPFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:05:37 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:43740 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820AbYKCPFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:05:37 -0500
Subject: Re: regulator: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1225594510.2142.20.camel@nga.site>
References: <1225594510.2142.20.camel@nga.site>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 15:05:31 +0000
Message-Id: <1225724731.12707.1.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-02 at 03:55 +0100, Kay Sievers wrote:
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
> 

Applied.

Thanks

Liam

