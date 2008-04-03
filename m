Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYDCNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYDCNaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYDCNab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:30:31 -0400
Received: from saeurebad.de ([85.214.36.134]:53508 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYDCNaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:30:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 01/22] Generic show_mem() implementation
References: <12071688283927-git-send-email-hannes@saeurebad.de>
	<1207168839586-git-send-email-hannes@saeurebad.de>
	<20080403075545.GC4125@osiris.boeblingen.de.ibm.com>
	<20080403124820.GA30356@uranus.ravnborg.org>
Date: Thu, 03 Apr 2008 15:30:23 +0200
In-Reply-To: <20080403124820.GA30356@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Thu, 3 Apr 2008 14:48:20 +0200")
Message-ID: <87abkboykw.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sam Ravnborg <sam@ravnborg.org> writes:

>> > +
>> > +config HAVE_ARCH_SHOW_MEM
>> > +	def_bool y
>> 
>> These are all not necessary. Better add some global Kconfig option that
>> gets selected by an arch if it wants the generic implementation.
>> 
>> e.g. we currently have this in arch/s390/Kconfig:
>> 
>> config S390
>>         def_bool y
>>         select HAVE_OPROFILE
>>         select HAVE_KPROBES
>>         select HAVE_KRETPROBES
>> 
>> just add a select HAVE_GENERIC_SHOWMEM or something like that in the arch
>> specific patches.
> Seconded.
> See Documentation/kbuild/kconfig-language.txt for a few more hints
> how to do it.

Yes, I will rework the patches.  Thanks.

	Hannes
