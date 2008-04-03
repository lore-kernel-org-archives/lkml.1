Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYDCNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYDCNI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYDCNIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:08:47 -0400
Received: from saeurebad.de ([85.214.36.134]:51351 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYDCNIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:08:47 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, ralf@linux-mips.org,
       kyle@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 18/22] sh: Use generic show_mem()
References: <12071688283927-git-send-email-hannes@saeurebad.de>
	<12071690311447-git-send-email-hannes@saeurebad.de>
	<20080403114124.GA25523@linux-sh.org>
Date: Thu, 03 Apr 2008 15:08:39 +0200
In-Reply-To: <20080403114124.GA25523@linux-sh.org> (Paul Mundt's message of
	"Thu, 3 Apr 2008 20:41:24 +0900")
Message-ID: <87ej9nozl4.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Mundt <lethal@linux-sh.org> writes:

> On Wed, Apr 02, 2008 at 10:40:24PM +0200, Johannes Weiner wrote:
>> -	printk(KERN_INFO "Total of %ld pages in page table cache\n",
>> -	       quicklist_total_size());
>> -}
>> -
>
> NACK. The quicklists are also absent from the generic implementation.
> Doing things generically is nice and all, but please do not go around
> removing all of the different implementations and consolidating on the
> simplest point of commonality you could come up with. Either combine
> everything in to a generic show_mem() that doesn't sacrifice
> functionality, or only convert the platforms that are identical.

Sorry, I made it an RFC because I was not quite sure if the generic pfn
walker is valid on all affected architectures.  If it is okay, I will
send a patch-set meant for application that does not miss any output.

Thanks,

	Hannes
