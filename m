Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbYCFKsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbYCFKsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbYCFKrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:47:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:14718 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbYCFKrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SfcSbrumZhu02y8GyCq+OM00SgIwgTGXxbAPQ9o+wJms6o82tyhcQKZzsY/3IZN76tsUizdnMGs7WTXGx5DHzr86W7Mj4PoKyL60XzZQ8f+Bt8KJ3FE6WC9DFSEwdboX1Ks5wmsvTKTrTXCOmzz7ozblpX1Wr29U1B0uhdnpkW0=
Message-ID: <a72f6a3c0803060247s5203b1f4n39ccf655c351c54d@mail.gmail.com>
Date: Thu, 6 Mar 2008 10:47:42 +0000
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: init process failed when booting linux
In-Reply-To: <81adadb6-afb6-4c75-8da7-b815e2a830fd@59g2000hsb.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <81adadb6-afb6-4c75-8da7-b815e2a830fd@59g2000hsb.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 When I was booting my Linux (2.6.17) on my FPGA-prototyped system, the
 init process always failed. Below is the serial console message I've
 got:

 <6>Freeing init memory: 584K
 Freeing init memory: 584K
 ø<6>/init exit code: -14
 /init exit code: -14
 <4>Failed to execute /init
 Failed to execute /init

 Things went wrong from the third line. I've looked at the
 corresponding linux code, the boot process stopped at a data abort
 exception from address in __arch_clear_user at 0xc012ad44. Any ideas
 on why this is happening and possible ways to fix it would be greatly
 appreciated.


 Jack
