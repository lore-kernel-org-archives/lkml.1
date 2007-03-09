Return-Path: <linux-kernel-owner+w=401wt.eu-S2992953AbXCIE1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992953AbXCIE1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992955AbXCIE1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:27:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:31311 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992953AbXCIE1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VoMA8g8zt0rsnvnfAOwSV99n2DIBTTAa2Ms6CjAgff/y5lZrqweM2V4mRHxnChCSSLKJyn2a7V6o8VpO5n5aGLP1x67SRT5vsA1rwOTCy1qIQUjtd9oLU6bpx6zGpJGEZKifSSypxSLWSHOR+p4amhaOAPRNk8JWGyK4Q4DsRRY=
From: Quinn Storm <livinglatexkali@gmail.com>
Organization: Beryl
To: linux-kernel@vger.kernel.org
Subject: NVidia early quirk repair patch bug
Date: Thu, 8 Mar 2007 23:27:40 -0500
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082327.40782.livinglatexkali@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In attempting to fix some issues with my system, I was pulling patches from 
the kernel git tree, and I discovered that this patch (
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fe69933652562f093ccde600cecf234930c01932 )
is malformed on i386, specifically the line:

+               if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check) {

should read

+               if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {

I know someone else would have caught this, but I figured since I was doing 
this I'd post about it.

btw, thanks for the wonderful work guys, wanted to mention bcm43xx finally 
works properly on 2.6.21-rc3 w/ my 4311
