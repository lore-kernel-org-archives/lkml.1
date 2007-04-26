Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXDZIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXDZIOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXDZIOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:14:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:48650 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbXDZIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ugp7ambg+xTvAkAZI5sTJ9jYKfTq85+a9D7PtXfLQ+j97PMlLwDOJd2C24u4UIIfwOlOIJayGGTryEudDe4fnnHELcN4ix/gpkwFVykYa9bItgdm1P7CQnTlOCMr9HXv7lcxY3h3n6AAOQjQPV0sj+y3SmINsYbTC8S1/HQrvoU=
Message-ID: <299ffe0d0704260059x466bda7dt8fe004071931cbb0@mail.gmail.com>
Date: Thu, 26 Apr 2007 10:59:56 +0300
From: "OOzy Pal" <oozypal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel Patch
In-Reply-To: <299ffe0d0704260057r37c2669ekb2f3e504dcd676c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <299ffe0d0704260057r37c2669ekb2f3e504dcd676c8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dears,

I am not sure if this is the right place for asking such question. If
not, please ignore and if possible, direct me to the right place.

I am trying to rebuilt my kernel patched with the iwlwifi driver. I
downloaded the mac80211 package then I typed make. I got the following
error. Can you help me in solving this error.

Note: I am a noob.

hab@laptop {~/wifi/mac80211-7.0.6}$ sudo make
Building modified version in 'modified/' directory:
Copying modified/ from origin/...done
Applying patches and scripts from pending/.
 + Applying: pending/09-range-name-rate.patch
        Add WE range, name and rate capabilities
 + Applying: pending/10-txpower.patch
        Fix user specified TXPOWER from being overridden by stack.
 + Applying: pending/20-wireless-dev-qos.patch
        The attachment is the QoS patch for the latest wireless-dev GIT
 + Applying: pending/21-fix_qos_entries_not_found.patch
        From: Zhu Yi <yi.zhu@intel.com>
Checking kernel compatibility in:
        /lib/modules/2.6.20-15-generic/source//
 * Kernel requires compatibility version:
   - Requires class_dev -> dev API compat
   - Requires to_net_dev API compat
   - Requires device_rename compat
Building compatibility version in 'compatible/' directory:
Copying compatible/ from modified/...done
 + Applying: patches/remove_debugfs.patch
        Remove DEBUGFS usage (due to class_dev breakage)
 + Applying: patches/class_dev_to_dev-wireless.patch
        Reverse class_dev to dev changes
 + Applying: patches/add_to_net_dev.patch
        Add to_net_dev back in (newer kernels have it in netdevice.h)
 + Applying: patches/fix-qos-sysfs-no-class_dev.patch
        diff -upr pre/net/mac80211/ieee80211_sysfs.c
post/net/mac80211/ieee80211_sysfs.c
 + Applying: patches/nl80211-remove-kconfig.patch
        Remove nl80211 from being an option in Kconfig
 + Applying: patches/device_rename.patch
        The ability to rename devices requires device_rename so we can't use it.


--
OOzy
Ubuntu-Feisty
