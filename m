Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZLDWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZLDWZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZLDWZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:25:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZLDWZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:25:06 -0500
Message-ID: <4B198C18.7040500@zytor.com>
Date: Fri, 04 Dec 2009 14:24:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity verification
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204221553.GD32314@elf.ucw.cz>
In-Reply-To: <20091204221553.GD32314@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 02:15 PM, Pavel Machek wrote:
>>>
>>> Are  you sure x86-64 kernel & modules is always below 4GB? I don't
>>> think so.

The x86-64 kernel is run where it is loaded by the boot loader.  For
most boot loaders, that will mean < 4 GB.  This is not the case for
modules, and they cannot and should not rely on modules inside
restricted zone.

This effectively becomes a constraint on whatever boot loader is used to
load the kernel for it to be compatible with tboot.

	-hpa
