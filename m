Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZGJSsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZGJSsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZGJSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:48:46 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33900 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752954AbZGJSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:48:45 -0400
Date: Fri, 10 Jul 2009 14:48:37 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <20090710094934.17CA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907101447370.14152@gentwo.org>
References: <20090709171247.23C6.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907091638330.17835@gentwo.org> <20090710094934.17CA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, KOSAKI Motohiro wrote:

> Plus, current reclaim logic depend on the system have enough much pages on LRU.
> Maybe we don't only need to limit #-of-reclaimer, but also need to limit #-of-migrator.
> I think we can use similar logic.

I think your isolate pages counters can be used in both locations.

