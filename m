Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXCVMjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXCVMjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXCVMjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:39:05 -0400
Received: from mail1.key-systems.net ([81.3.43.211]:57967 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752769AbXCVMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:39:04 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 08:39:03 EDT
Message-ID: <46027752.4040206@scientia.net>
Date: Thu, 22 Mar 2007 13:32:18 +0100
From: Christoph Anton Mitterer <calestyo@scientia.net>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Robert Hancock <hancockr@shaw.ca>, cw@f00f.org, knweiss@gmx.de, ak@suse.de,
       andersen@codepoet.org, krader@us.ibm.com, lfriedman@nvidia.com,
       linux-nforce-bugs@nvidia.com, ak@suse.de
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives // memory
 hole mapping related bug?!
References: <fa.E9jVXDLMKzMZNCbslzUxjMhsInE@ifi.uio.no> <459C3F29.2@shaw.ca> <45AC06B2.3060806@scientia.net>
In-Reply-To: <45AC06B2.3060806@scientia.net>
Content-Type: multipart/mixed;
 boundary="------------050404080601070802050702"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050404080601070802050702
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi folks.

1) Are there any new developments in this issue? Does someone know if
AMD and Nvidia is still investigating?

2) Steve Langasek from Debian sent me a patch that disables the hw-iommu
per default on Nvidia boards.
I've attached it in the kernel bugzilla and asked for inclusion in the
kernel (until we find a real solution).
I'd be pleased if all of you (who experienced the data corruption) could
test this patch.
Note: This patch is NOT a real solution for the issue, it just applies
our workaround (iommu=soft) per default

Bugreport at kernel.org: http://bugzilla.kernel.org/show_bug.cgi?id=7768
Bugreport at Debian: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=404148

Best wishes,
Chris.

--------------050404080601070802050702
Content-Type: text/x-vcard; charset=utf-8;
 name="calestyo.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="calestyo.vcf"

YmVnaW46dmNhcmQNCmZuOk1pdHRlcmVyLCBDaHJpc3RvcGggQW50b24NCm46TWl0dGVyZXI7
Q2hyaXN0b3BoIEFudG9uDQplbWFpbDtpbnRlcm5ldDpjYWxlc3R5b0BzY2llbnRpYS5uZXQN
CngtbW96aWxsYS1odG1sOlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------050404080601070802050702--
