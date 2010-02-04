Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0BDSGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:06:49 -0500
Received: from xes-mad.com ([216.165.139.218]:35372 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab0BDSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:06:47 -0500
X-Greylist: delayed 2654 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 13:06:47 EST
Subject: Re: [PATCH 6/7] edac: mpc85xx fsb ecc
From: Peter Tyser <ptyser@xes-inc.com>
To: dougthompson@xmission.com
Cc: kolifer@gmail.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4b6a6d39.qA/tt48S/7odhQ+i%dougthompson@xmission.com>
References: <4b6a6d39.qA/tt48S/7odhQ+i%dougthompson@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 11:22:14 -0600
Message-ID: <1265304134.14589.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug and Konstantin,

On Wed, 2010-02-03 at 23:46 -0700, dougthompson@xmission.com wrote:
> From: Konstantin Olifer <kolifer@gmail.com>
> 
> Patch is for Kernel 2.6.33. e752x_edac suppose that fsb ECC exist, for example, on
> Celeron + 3100. That is wrong. 
> ECC FSB supported only on Xeon for our vision (www.setdsp.ru) and datasheet from developer intel www. 
> Fixed.
> Signed-off-by:  Konstantin Olifer <kolifer@gmail.com>
> Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
> ---
>  e752x_edac.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

It looks like 6/7 and 7/7 in this series have the wrong subject/title.
Patches 6 and 7 are for the e752x instead of the mpc85xx.

When changing the subjects, it might be nice to change this commit
message to something more straightforward such as:
"FSB parity is only supported on the Xeon processor.  Previously it was
incorrectly enabled for the Celeron as well."

Best,
Peter

