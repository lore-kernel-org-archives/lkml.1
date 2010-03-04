Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0CDVI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:08:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0CDVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:08:25 -0500
Subject: Re: [PATCH 09/14] perf, x86: use LBR for PEBS IP+1 fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <4B901E23.4080701@redhat.com>
References: <20100304140046.596569763@chello.nl>
	 <20100304140100.619375431@chello.nl>  <4B8FDE16.3050403@redhat.com>
	 <1267725262.25158.206.camel@laptop>  <4B901E23.4080701@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 22:08:22 +0100
Message-ID: <1267736902.16716.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 15:54 -0500, Masami Hiramatsu wrote:

> Anyway, would you mean that perf_instruction_pointer() will
> have different implementation by Yanmin?

Yes, he will also be checking if we came from guest context:

http://www.mail-archive.com/kvm@vger.kernel.org/msg29830.html

