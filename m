Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZCISvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZCISvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCISu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:50:57 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43203 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752780AbZCISu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:50:56 -0400
Date: Mon, 9 Mar 2009 14:50:06 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903091448110.20314@qirst.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again these are fastpath modifications.

Scanning the partial list for matching nodes is an expensive operation.

Adding RCU into the fast paths is also another big worry.

