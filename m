Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYIPOJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYIPOJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYIPOI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:08:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37219 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752234AbYIPOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:08:56 -0400
Date: Tue, 16 Sep 2008 15:08:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.27-rc6] PCI: Fix pcie_aspm=force
Message-ID: <20080916150851.4f1c8489@lxorguk.ukuu.org.uk>
In-Reply-To: <1221571633.4060.19.camel@galvatron>
References: <1221571633.4060.19.camel@galvatron>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 14:27:13 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> From: Sitsofe Wheeler <sitsofe@yahoo.com>
> 
> pcie_aspm=force did not work because aspm_force was being double negated
> leading to the sanity check failing. Moving a bracket should fix this.
> 
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Acked-by: Alan Cox <alan@redhat.com>
