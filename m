Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXLNMrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXLNMrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764533AbXLNMrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:47:36 -0500
Received: from saeurebad.de ([85.214.36.134]:44710 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764307AbXLNMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:47:35 -0500
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, rusty@rustcorp.com.au
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
References: <200712141225.30099.srinivasa@in.ibm.com>
	<20071213230916.cd30de8c.akpm@linux-foundation.org>
	<200712141500.46848.srinivasa@in.ibm.com>
	<200712141547.57121.srinivasa@in.ibm.com>
Date: Fri, 14 Dec 2007 13:46:35 +0100
In-Reply-To: <200712141547.57121.srinivasa@in.ibm.com> (Srinivasa Ds's message
	of "Fri, 14 Dec 2007 15:47:57 +0530")
Message-ID: <x7wsrh78b8.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Srinivasa Ds <srinivasa@in.ibm.com> writes:

> Forgot to change non_init_core_kernel_text() to regular_core_kernel_text().
> Resending the patch.
>
> [...]
>
> This patch creates non_init_kernel_text_address() to identify
> non_init text area.

You still refer to the old name here :)

How about persistent_core_kernel_text() and
persistent_kernel_text_address()?

	Hannes
