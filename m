Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZFDOHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZFDOHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZFDOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:07:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:28585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFDOHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PA8cRwbBahgwmuNtLhvNrqMNH2NrjcpMRm4pRCu4Yd5vfTyeYljkaE71ORZEjSyuDh
         cR5UmUROg2d6zz9UeB+TgGU9jdYE326o098FFSxlozD59+5tIxN9PStK3UsGx30wSRr5
         VWJHobXceUqd8CgHLE8Tm2Qt5HTGj5GBkrkrI=
MIME-Version: 1.0
In-Reply-To: <20090604133152.19022.27114.sendpatchset@subratamodak.linux.ibm.com>
References: <20090604133152.19022.27114.sendpatchset@subratamodak.linux.ibm.com>
Date: Thu, 4 Jun 2009 10:07:06 -0400
Message-ID: <9e4733910906040707o63f81dcdm571b9348ee081b30@mail.gmail.com>
Subject: Re: [BUILD FAILURE 02/04] Next June 04:PPC64 randconfig 
	[drivers/usb/host/ohci-hcd.o]
From: Jon Smirl <jonsmirl@gmail.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-usb@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Arnd Bergmann <arnd@arndb.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 9:31 AM, Subrata Modak
<subrata@linux.vnet.ibm.com> wrote:
> CC      drivers/usb/host/ohci-hcd.o
> In file included from drivers/usb/host/ohci-hcd.c:1060:
> drivers/usb/host/ohci-ppc-of.c:242:2: error: #error "No endianess selected for ppc-of-ohci"
> make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> make[2]: *** [drivers/usb/host] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2
>
> I reported this earlier, and there were some discussions:
> http://groups.google.co.kr/group/linux.kernel/browse_thread/thread/edff9d5572d3d225

Proposed patch by Arnd should fix this. It has not been merged.
http://lkml.org/lkml/2009/4/22/49

-- 
Jon Smirl
jonsmirl@gmail.com
