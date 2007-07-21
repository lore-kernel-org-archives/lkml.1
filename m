Return-Path: <linux-kernel-owner+w=401wt.eu-S934473AbXGUWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbXGUWE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763409AbXGUWEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:04:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56952 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763383AbXGUWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:04:19 -0400
Subject: RE: from where comes "__moddi3"?
From: Arjan van de Ven <arjan@infradead.org>
To: davids@webmaster.com
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEAPFIAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKGEAPFIAC.davids@webmaster.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 21 Jul 2007 15:02:42 -0700
Message-Id: <1185055362.2714.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 14:27 -0700, David Schwartz wrote:
> > On 7/21/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > > v & 0x0F  <=>  v % 16
> > Indeed. (Why would anyone want to mod/div by 15 anyway?). My bad.
> 
> Actually, it's the compiler's bad. That's a pretty fundamental equivalence that the compiler should recognize for native integral types.

for unsigned ones for sure yes... but the original question was about 15
not 16.


