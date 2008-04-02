Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYDBUNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYDBUNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYDBUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:13:35 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:10899 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990AbYDBUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rnoa0q8TnQyq+NoeiVGDBXW2KNn9e8oZYHoUdQfyLXjSlMMuTgH7unGb1UN0x10yOHi+Q052uaa7o2NAB3wAaZHDiVkn8LNuzoeSxUvWwkC/LiUKgi9mR2aJk5QpKs3UNnXkK6pwsnwxaTyAi6Jw9Dke3p8/bTPNq5mLwKUQpG0=
Message-ID: <1ba2fa240804021313l59b34b7cy5fba78d62d9fac58@mail.gmail.com>
Date: Wed, 2 Apr 2008 23:13:33 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm1_--_drivers/ne?= =?WINDOWS-1252?Q?t/wireless/iwlwifi/iwl-led.c:184?= =?WINDOWS-1252?Q?:_error:_=91struct_iwl=5Fpriv=92_has_n?= =?WINDOWS-1252?Q?o_member_named_=91last=5Fblink=5Ftime=92?=
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Zhu Yi" <yi.zhu@intel.com>,
       wireless <linux-wireless@vger.kernel.org>, reinette.chatre@intel.com
In-Reply-To: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 2:04 PM, Miles Lane <miles.lane@gmail.com> wrote:




>  CONFIG_IWLCORE=m
>  CONFIG_IWLWIFI_LEDS=y
>  # CONFIG_IWL4965 is not set
>  CONFIG_IWL3945=m
>  # CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
>  # CONFIG_IWL3945_LEDS is not set
>  # CONFIG_IWL3945_DEBUG is not set

This is a known problem please do use CONFIG_IWLWIFI_LEDS=y when not
compiling IWL4965
The fix need some more coding, we will fix this soon.
Thanks
Tomas
