Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbZCPSCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbZCPSCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbZCPRzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:55:43 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41402 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761047AbZCPRzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:55:42 -0400
Date: Mon, 16 Mar 2009 12:41:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903131620200.1881@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903161239450.17730@qirst.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com> <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com> <alpine.DEB.1.10.0903131630530.1741@qirst.com>
 <alpine.DEB.2.00.0903131620200.1881@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the nodes are exclusive to a load then the cpus attached to those nodes
are also exclusive? If so then there is no problem since the percpu queues
are only in use for a specific load with a consistent restriction on
cpusets and a consistent memory policy. Thus there is no need for
memory_slab_hardwall.
