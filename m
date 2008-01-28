Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYA1JXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYA1JXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYA1JXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:23:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYA1JXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:23:45 -0500
Date: Mon, 28 Jan 2008 01:22:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC] Per-thread getrusage
Message-Id: <20080128012245.cee1f9ea.akpm@linux-foundation.org>
In-Reply-To: <200801281354.12387.sripathik@in.ibm.com>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	<20080127215242.b873c341.akpm@linux-foundation.org>
	<200801281354.12387.sripathik@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 13:54:12 +0530 Sripathi Kodi <sripathik@in.ibm.com> wrote:

> Does Roland's patch (http://lkml.org/lkml/2008/1/18/589) look good to go 
> in, provided Ulrich's comment (http://lkml.org/lkml/2008/1/19/15) is 
> addressed?

Sure, it looks sane - it avoids the problematic get_task_by_pid() too.
