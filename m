Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0CCAms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:42:48 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:49392 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab0CCAmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:42:46 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
Date: Wed, 3 Mar 2010 01:42:41 +0100
User-Agent: KMail/1.9.9
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003021619.34793.elendil@planet.nl> <20100303000134.GD6786@linux.vnet.ibm.com>
In-Reply-To: <20100303000134.GD6786@linux.vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003030142.43310.elendil@planet.nl>
X-OriginalArrivalTime: 03 Mar 2010 00:42:44.0242 (UTC) FILETIME=[70090720:01CABA6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010, Paul E. McKenney wrote:
> > Wouldn't it be more logical to include the line in the dmesg output?
> > My preference would be a separate line below the existing (Linux
> > version) line. That line could only be output if the kernel was built
> > from a VCS. It could then even be repeated in oops output.
>
> My concern with only putting it in the dmesg output is that people do
> not always capture that.  The oops output is more often captured, but
> the kernel only has this information if CONFIG_LOCALVERSION_AUTO is set.

Yes, my suggestion is exactly because IMO it should be independent of 
CONFIG_LOCALVERSION_AUTO.

I hugely dislike that option because it makes the git version part of the 
kernel version and thus affects how the kernel gets installed (names of 
files in /boot, name of the directory in /lib/modules, name of the Debian 
package created using the deb-pkg target, etc.).
For all those things I want a "clean" kernel version and thus I will never 
enable CONFIG_LOCALVERSION_AUTO.

But I do see the value of a reliable and consistent identification of what 
exact source a kernel was built from. Including the git version separately 
from the kernel version would allow that.

Cheers,
FJP
