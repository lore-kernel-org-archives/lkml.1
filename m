Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYCKQus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYCKQus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYCKQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:50:41 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:39588 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYCKQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZoTaFeDeWLx+G1oR8pbWxx2ac0QeY67z/cC4a6W+tJwWMTE/jKhNeVqZY06N3nPdn0eiVHdDMrXiklM3dFYGsGRKUj2iCn5PWfwnbjE+1aUnjZz5wx8lmv1mD8WiIgibJygCKMqScQV7r1StH19jf/RLTn15eFnGy2i7gfH35QY=
Message-ID: <7c86c4470803110950p54349250pbe29d4122912a2f6@mail.gmail.com>
Date: Tue, 11 Mar 2008 09:50:36 -0700
From: "stephane eranian" <eranian@googlemail.com>
To: gregkh@suse.de
Subject: [PATCH 3/3] perfmon x86 infra(take 2): add AMD Northbridge PCI Id
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7c86c4470803071305x6b575dxa9f7b0588abfd4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470803071305x6b575dxa9f7b0588abfd4b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Ingo suggested I send ou the following patch which adds a PCI ID
for AMD Barcelona Northbridge. This is used by the perfmon initialization
code on this platform.

Please apply to your tree.
Thanks.

---------------------------------------------------

adds AMD Northbridge PCI Id

 Signed-off-by: Stephane Eranian <eranian@gmail.com>
 Signed-off-by: Robert Richter <robert.richter@amd.com>

 --- a/include/linux/pci_ids.h
 +++ b/include/linux/pci_ids.h
 @@ -497,6 +497,8 @@
  #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP        0x1101
  #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL 0x1102
  #define PCI_DEVICE_ID_AMD_K8_NB_MISC   0x1103
 +#define PCI_DEVICE_ID_AMD_10H_NB       0x1200
 +#define PCI_DEVICE_ID_AMD_10H_NB_MISC  0x1203
  #define PCI_DEVICE_ID_AMD_LANCE                0x2000
  #define PCI_DEVICE_ID_AMD_LANCE_HOME   0x2001
  #define PCI_DEVICE_ID_AMD_SCSI         0x2020
