Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbZFLOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbZFLOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZFLOqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:46:52 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50114 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893AbZFLOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:46:52 -0400
Date: Fri, 12 Jun 2009 10:30:03 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early SLAB fixes for 2.6.31
In-Reply-To: <1244814306.30512.65.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906121026280.13365@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <1244813895.7172.157.camel@pasglop> <1244814306.30512.65.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having to use GFP_NOWAIT instead of GFP_KERNEL in code that may perhaps be
used in early boot defeats the purpose of the whole endeavor. Some of
these function may also be used after boot and thus we will have to add
special casing so that GFP_KERNEL is used if boot is complete. We are
replacing one special casing with another.
