Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbZJ1JKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbZJ1JKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932748AbZJ1JKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:10:19 -0400
Received: from darkstar.wilibox.com ([195.14.175.138]:50723 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbZJ1JKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:10:18 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 05:10:18 EDT
Message-ID: <4AE807F8.2040909@gmail.com>
Date: Wed, 28 Oct 2009 10:59:36 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, greg@kroah.com
Subject: Re: staging/dream: add gpio and pmem support
References: <20091022091333.GA31023@elf.ucw.cz>
In-Reply-To: <20091022091333.GA31023@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 12:13 PM, Pavel Machek wrote:
>
> This adds generic_gpio and pmem support, both are needed for other
> dream drivers.

Why you are not using existing gpiolib? That would make your driver a
lot smaller and cleaner... and possibly with less bugs...

Why not split gpio and pmem into separate patches?

> Signed-off-by: Pavel Machek<pavel@ucw.cz>
