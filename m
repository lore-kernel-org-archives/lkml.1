Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbXA3EJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbXA3EJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965056AbXA3EJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:09:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:59237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982AbXA3EJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:09:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 2/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Tue, 30 Jan 2007 05:08:56 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F55.8070801@us.ibm.com>
In-Reply-To: <45BE4F55.8070801@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701300508.56467.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+9XGf+xR+y2Gdk20Lp9h4mHpmp13tl4QszEjCxczomRJGnJWIOhBVbY+ug5hy8yXW+UcMQ+ljqE832/3aO81AlnuINax37Otbt0Df6A/t11w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 20:47, Maynard Johnson wrote:
>   The code was setting up the debug bus for group 21 when profiling on the 
> event PPU CYCLES.  The debug bus is not actually used by the hardware 
> performance counters when counting PPU CYCLES.  Setting up the debug bus
> for PPU CYCLES causes signal routing conflicts on the debug bus when 
> profiling PPU cycles and another PPU event.  This patch fixes the code to 
> only setup the debug bus to route the performance signals for the non
> PPU CYCLE events.
> 
> Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
> Signed-off-by: Carl Love <carll@us.ibm.com>

Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

Any suggestion for a one-line patch title?
