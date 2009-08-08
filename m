Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZHHA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZHHA3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZHHA3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:29:17 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:44235 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZHHA3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=wkilLKjLf1pMBVtUuXEZzMCYAzVZvbvWg+f58DKcKWD46qKHWrpeJp5R3vlsGaiAN6
         bbDpnKDBQ3pStBVAyxwVCaXkUn9q2KKq2LrNCCnX1zIDYwhHEZ3leyoxX9SoNvnGqahK
         MlrmbfIgekNlPlVrO37nZpm56SbnGiL092yZI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Fri, 7 Aug 2009 17:29:05 -0700
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <1248404514.2670.107.camel@rzhang-dt> <1249439048.2670.454.camel@rzhang-dt> <200908080222.03172.rjw@sisk.pl>
In-Reply-To: <200908080222.03172.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <20090808005922.110A3526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 17:22:03 Rafael J. Wysocki wrote:
> +       device_enable_async_pm(&i8042_platform_device->dev, true);
> +

Please don't do that, at least not right now. i8042 being the fine
piece of {soft,hard}ware as it is will not like when you start banging
on all its ports at the same time.

-- 
Dmitry
