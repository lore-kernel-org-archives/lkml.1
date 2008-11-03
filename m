Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYKCT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYKCT7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKCT7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:59:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:46027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYKCT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:59:14 -0500
Date: Mon, 3 Nov 2008 11:59:52 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: logging server C-state time?
Message-ID: <20081103115952.69276f61@linux.intel.com>
In-Reply-To: <490F5568.2090003@redhat.com>
References: <490F5568.2090003@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 14:47:52 -0500
Chris Snook <csnook@redhat.com> wrote:

> Hey folks --
> 
> I'm interested in logging the amount of time that server CPUs spend
> in various C-states over the course of a complicated job, ideally in
> a manner I could sync up with output from sysstat tools.  So far all
> the tools I've seen for power monitoring seem to be targeted to
> laptops and interactive use, but I'm looking for something that's
> scriptable and doesn't need ACPI battery information, even if that
> means relying on indirect measurements of power use like C-states.
> Any suggestions?

powertop gives you the C state information accumulated over time...
just look at the code how it does that ;)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
