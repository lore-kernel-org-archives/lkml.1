Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbZD0V71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbZD0V71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbZD0V56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:57:58 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34528 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760892AbZD0V54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <20090427180036.269a40b3@hyperion.delvare>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<20090330104952.26f03c13@hyperion.delvare> <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> 
	<20090426085401.3788fc9c@hyperion.delvare> <ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com> 
	<20090427180036.269a40b3@hyperion.delvare>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 27 Apr 2009 23:57:40 +0200
Message-ID: <ac3eb2510904271457w30aac8f5j9ee0d6508f8444c1@mail.gmail.com>
Subject: Re: Class device namespaces
To: Jean Delvare <khali@linux-fr.org>
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 18:00, Jean Delvare <khali@linux-fr.org> wrote:

> I'd like to give a try to converting i2c-adapter devices to bus devices
> rather than class devices, if you think that's how things should be.
> Can you please explain to me how this would be done?

Register a "i2c" bus_type with the core, and instead of assigning
dev.class = class, you assign dev.bus = bus to the devices you
register, that should work, if there is nothing more complicated going
on in the background.

Thanks,
Kay
