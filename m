Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXHHLee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXHHLee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXHHLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:34:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXHHLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:34:23 -0400
Subject: Re: [PATCH 21/25] [PATCH] export cpu_gdt_descr
From: Arjan van de Ven <arjan@infradead.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <11865468362401-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865467592921-git-send-email-gcosta@redhat.com>
	 <1186546763582-git-send-email-gcosta@redhat.com>
	 <11865467662182-git-send-email-gcosta@redhat.com>
	 <11865467702103-git-send-email-gcosta@redhat.com>
	 <11865467741753-git-send-email-gcosta@redhat.com>
	 <11865467773012-git-send-email-gcosta@redhat.com>
	 <11865467812610-git-send-email-gcosta@redhat.com>
	 <1186546785346-git-send-email-gcosta@redhat.com>
	 <1186546789356-git-send-email-gcosta@redhat.com>
	 <11865467931543-git-send-email-gcosta@redhat.com>
	 <11865467973510-git-send-email-gcosta@redhat.com>
	 <11865468003673-git-send-email-gcosta@redhat.com>
	 <11865468043920-git-send-email-gcosta@redhat.com>
	 <118654680831-git-send-email-gcosta@redhat.com>
	 <11865468122642-git-send-email-gcosta@redhat.com>
	 <11865468162812-git-send-email-gcosta@redhat.com>
	 <1186546820708-git-send-email-gcosta@redhat.com>
	 <11865468243612-git-send-email-gcosta@redhat.com>
	 <11865468281860-git-send-email-gc! osta@redhat.com>
	 <11865468321629-git-send-email-gcosta@redhat.com>
	 <11865468362401-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 08 Aug 2007 04:32:25 -0700
Message-Id: <1186572745.2862.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 01:19 -0300, Glauber de Oliveira Costa wrote:
> With paravirualization, hypervisors needs to handle the gdt,
> that was right to this point only used at very early
> inialization code. Hypervisors are commonly modules, so make
> it an export
> 

the GDT is so deeply internal that this really ought to be a _GPL
export..


