Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbXEVXv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbXEVXv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXEVXvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:51:22 -0400
Received: from homer.mvista.com ([63.81.120.158]:3437 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbXEVXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:51:21 -0400
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable
	preemption
From: Daniel Walker <dwalker@mvista.com>
To: Kevin Hilman <khilman@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1179877296.6122.74.camel@vence.hilman.org>
References: <20070522230128.891568116@mvista.com>
	 <1179876320.15427.214.camel@imap.mvista.com>
	 <1179877296.6122.74.camel@vence.hilman.org>
Content-Type: text/plain
Date: Tue, 22 May 2007 16:48:54 -0700
Message-Id: <1179877734.15427.218.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 16:41 -0700, Kevin Hilman wrote:
 
> 
> Individually, yes.  But the point of the preempt_disable/enable is to
> make the whole sequence atomic.

I was under the impression that only one of those mcr lines is called
per board type, the rest just compile away?

Daniel

