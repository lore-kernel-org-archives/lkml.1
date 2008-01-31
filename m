Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbYAaOHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbYAaOHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765995AbYAaOHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:07:17 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:50657 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765640AbYAaOHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:07:15 -0500
Date: Thu, 31 Jan 2008 15:04:28 +0100
Message-Id: <137932353@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?Re:_[PATCH]_x86:_introduce_/dev/mem_restrictions_with_?=
 =?iso-8859-15?Q?a_config_option?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+TVJWr5JT71VW29/GTy56PdHhSYB6PZ6oGnZMewIyeu1hJS
 OcDggKZV5pAM0Y1rxrkR1Xa55vz51fIaDWlR+tFwaEITnnHZnQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nice !

did you think about some boot-time param , e.g. "insecure-devmem" or something like that?

recompiling kernel is time consuming.....






From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] x86: introduce /dev/mem restrictions with a config option

This patch introduces a restriction on /dev/mem: Only non-memory can be
read or written unless the newly introduced config option is set.

The X server needs access to /dev/mem for the PCI space, but it doesn't need
access to memory; both the file permissions and SELinux permissions of /dev/mem
just make X effectively super-super powerful. With the exception of the
BIOS area, there's just no valid app that uses /dev/mem on actual memory.
Other popular users of /dev/mem are rootkits and the like.
(note: mmap access of memory via /dev/mem was already not allowed since
a really long time)

People who want to use /dev/mem for kernel debugging can enable the config
option.

The restrictions of this patch have been in the Fedora and RHEL kernels for
at least 4 years without any problems.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

