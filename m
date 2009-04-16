Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZDPTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZDPTsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDPTr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:47:59 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:35111
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756606AbZDPTr6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:47:58 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 15:47:58 EDT
X-BigFish: VPS-37(zz98dR936eQ1447R9371Pzz1202hzzz2fh6bh14bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <49E787DC.2050800@am.sony.com>
Date: Thu, 16 Apr 2009 12:32:44 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUILD FAILURE 03/12] Next April 14 : PPC64 randconfig	[arch/powerpc/platforms/ps3/setup.c]
References: <1239733704.5344.75.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1239733704.5344.75.camel@subratamodak.linux.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 16 Apr 2009 19:32:45.0407 (UTC) FILETIME=[1E1406F0:01C9BECA]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2009 11:28 AM, Subrata Modak wrote:
> Observed the following build error:
> ---
> arch/powerpc/platforms/ps3/setup.c:49: error: redefinition of
> ‘smp_send_stop’
> include/linux/smp.h:125: error: previous definition of ‘smp_send_stop’
> was here

Hi Subrata,

Thanks for the report.  I submitted a fix to the powerpc ML:

 http://patchwork.ozlabs.org/patch/26084/

-Geoff

