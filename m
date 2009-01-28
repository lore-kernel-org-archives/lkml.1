Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZA1Qmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZA1Qmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZA1Qmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:42:37 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40631 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbZA1Qmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:42:36 -0500
Date: Wed, 28 Jan 2009 11:38:39 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: miaox@cn.fujitsu.com, mingo@elte.hu, menage@google.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
In-Reply-To: <20090127144233.18cf9b3f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901281137480.7765@qirst.com>
References: <4976D77C.3020107@cn.fujitsu.com> <20090127144233.18cf9b3f.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What exactly is breaking? You do a memory spread in a set of nodes
determined by the cpuset? Or how do you restrict the nodes that memory
spread is allowed to cycle through?



