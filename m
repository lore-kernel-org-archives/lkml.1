Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZGNVAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZGNVAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZGNVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:00:35 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:58110 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZGNVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:00:35 -0400
Message-ID: <4A5CFFD8.7020106@t-online.de>
Date: Tue, 14 Jul 2009 22:59:52 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090709)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> <20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com>
In-Reply-To: <6206.1247592126@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: EwwjnrZ-YhxKuegdN3-mTAAuml0IFJlZgmeQnOG83yRRsNLJfbKBdbgfJraqhVzg4g
X-TOI-MSGID: 13f5056e-24b8-43bf-99ec-cfceb2393870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Mike Frysinger <vapier@gentoo.org> wrote:
> 
>> Some architectures (like the Blackfin arch) implement some of the
>> "simpler" features that one would expect out of a MMU such as memory
>> protection.  In our case, we actually get read/write/exec protection
>> down to the page boundary so processes can't stomp on each other let
>> alone the kernel.  There is a performance decrease (which depends greatly
>> on the workload) however as the hardware/software interaction was not
>> optimized at design time.
> 
> It occurs to me that I could probably test this on FRV by using the MMU in a
> limited way.  How do you actually keep track of the protections applied?  Do
> you have a single global page table that is managed by the mmap code on a
> per-VMA basis?

No page table, just three bitmaps (r/w/x), with one bit per page, per mm.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
