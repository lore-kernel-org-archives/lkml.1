Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZKVRMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZKVRMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZKVRMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:12:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:57986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZKVRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:12:07 -0500
Date: Sun, 22 Nov 2009 09:13:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: use default compiler mode by default
Message-ID: <20091122091338.4a9d772f@infradead.org>
In-Reply-To: <20091122121335.GA24254@redhat.com>
References: <20091122121335.GA24254@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 14:13:35 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> gcc with no flags typically is a sane default for systems to use, and
> looking at the running kernel is probably broken for cross-builds
> anyway, so let's not do this.  Add EXTRA_CFLAGS so that users can
> override default gcc mode if they want to.
> 


yes please; current perf breaks if you compile it in a 32 bit chroot on
a 64 bit system.... 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
