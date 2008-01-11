Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbYAKBjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbYAKBjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYAKBjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:39:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:63327 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYAKBjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ts7JtyhFzd7bjsxRthKJ2HRNk+LKG875BkyWdQ32rIbkBaDLnA8q4bDbzgLnQ3qWGiy4yZJbCkBYNajsVVUMLvdlY2MNKZrzdithtgKl6+ilUCKFNn2LJHf4MZnXP5QP955sGlsE5k6TFE+0EXvOkqnfzbQi9acAaILWIcndyxE=
Message-ID: <b25c3fa70801101738j512a6189i3e4541bf0348b91f@mail.gmail.com>
Date: Fri, 11 Jan 2008 10:38:59 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1200013607.3530.128.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11998765783953-git-send-email-joonwpark81@gmail.com>
	 <1200013607.3530.128.camel@debian.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/11, Zhu Yi <yi.zhu@intel.com>:
> Hi Joonwoo,
>
> We already did something similiar in our code base. Could you please
> take a look at this patch?
>
> http://intellinuxwireless.org/repos/?p=iwlwifi.git;a=commitdiff;h=57aa02255e9d7be5e2494683fc2793bd1d0707e2
>
> Thanks,
> -yi

Ooops :-)
I should have checked code base, it's my fault.
it's seems very similar, but I could not made build unfortunately.
Can you introduce to me how to build it please?

my build error is here:
jason@ehus ~/SRC/DRIVERS/iwlwifi $ KSRC=/home/jason/SRC/LINUX/linux-2.6 make
make -C /home/jason/SRC/LINUX/linux-2.6 O=
M=/home/jason/SRC/DRIVERS/iwlwifi/compatible/
EXTRA_CFLAGS="-DCONFIG_IWL3945_DEBUG=y -DCONFIG_IWL4965_DEBUG=y
-DCONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
-DCONFIG_IWL4965_SPECTRUM_MEASUREMENT=y -DCONFIG_IWL4965_SENSITIVITY=y
-DCONFIG_IWL3945_QOS=y -DCONFIG_IWL4965_QOS=y" modules
make[1]: Entering directory `/home/jason/SRC/LINUX/linux-2.6'
  CC [M]  /home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.o
In file included from
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:51:
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl-3945.h:443: error:
expected specifier-qualifier-list before 'ieee80211_key_alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_add_station':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:539: error:
implicit declaration of function 'MAC_ARG'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:539:
warning: too few arguments for format
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_commit_rxon':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1161:
warning: too few arguments for format
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_update_sta_key_info':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1400: error:
'struct iwl3945_hw_key' has no member named 'alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1401: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1402: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:1402: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c: In function
'iwl3945_build_tx_cmd_hwcrypto':
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2594: error:
'struct iwl3945_hw_key' has no member named 'alg'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'key'
/home/jason/SRC/DRIVERS/iwlwifi/compatible/iwl3945-base.c:2597: error:
'struct iwl3945_hw_key' has no member named 'keylen'


Thanks,
Joonwoo
