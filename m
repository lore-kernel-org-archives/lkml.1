Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYIYV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYIYV3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYIYV32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:29:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:40952 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYIYV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=JrFzkgYq+UL7DTfrU9DjHKb6f0+j1SjKtfZWZS4xC0BSa5UYHWI8fSAMJRzuBuJkx/
         uSk0DOQFIa+etxZJcYyGC0aYT0P/4Qi98xgYY3AOWg3J577FV48eHtZJR+ii43OCsgA1
         y/cWEbmdrpxa7phU70Ziu4/Do5WpnpkfVjOY4=
Message-ID: <9f8af95f0809251429n289229beo80cf6ef3c5ef600c@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:29:25 -0400
From: "james toy" <unk.nown@unix.net>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: 20080923-mmotm arch/x86/kvm/built-in.o: In function `kvm_dev_ioctl_check_extension':
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 34644f7251994b0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this break with virtualization enabled on the latest mmotm.

 CC      net/wireless/util.o
 CC [M]  net/sunrpc/auth_gss/gss_krb5_unseal.o
 CC [M]  drivers/usb/storage/freecom.o
 CC [M]  net/sunrpc/auth_gss/gss_krb5_seqnum.o
 CC [M]  drivers/usb/storage/dpcm.o
 CC      net/wireless/reg.o
 CC [M]  net/sunrpc/auth_gss/gss_krb5_wrap.o
 CC [M]  drivers/usb/storage/isd200.o
 CC [M]  net/sunrpc/auth_gss/gss_krb5_crypto.o
 CC      net/wireless/nl80211.o
 CC [M]  drivers/usb/storage/datafab.o
 LD [M]  net/sunrpc/auth_gss/auth_rpcgss.o
 LD [M]  net/sunrpc/auth_gss/rpcsec_gss_krb5.o
 LD [M]  net/sunrpc/sunrpc.o
 CC [M]  drivers/usb/storage/jumpshot.o
 CC      net/xfrm/xfrm_policy.o
 LD      net/wireless/cfg80211.o
 LD      net/wireless/built-in.o
 CC [M]  drivers/usb/storage/alauda.o
 CC      net/compat.o
 CC [M]  drivers/usb/storage/karma.o
 CC [M]  drivers/usb/storage/libusual.o
 CC      net/sysctl_net.o
 CC      net/xfrm/xfrm_state.o
 LD [M]  drivers/usb/storage/usb-storage.o
 LD      drivers/usb/built-in.o
 CC      net/xfrm/xfrm_hash.o
 LD      drivers/built-in.o
 CC      net/xfrm/xfrm_input.o
 CC      net/xfrm/xfrm_output.o
 CC      net/xfrm/xfrm_algo.o
 CC      net/xfrm/xfrm_user.o
 CC      net/xfrm/xfrm_ipcomp.o
 LD      net/xfrm/built-in.o
 LD      net/built-in.o
 LD      vmlinux.o
 MODPOST vmlinux.o
WARNING: modpost: Found 17 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
 GEN     .version
 CHK     include/linux/compile.h
 UPD     include/linux/compile.h
 CC      init/version.o
 LD      init/built-in.o
 LD      vmlinux
arch/x86/kvm/built-in.o: In function `kvm_dev_ioctl_check_extension':
(.text+0x6a71): undefined reference to `intel_iommu_found'
make: *** [vmlinux] Error 1
[bbs@raider zenmm]$

/jT
