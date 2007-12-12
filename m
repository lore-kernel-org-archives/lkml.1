Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXLLFjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXLLFjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXLLFjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:39:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbXLLFjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:39:23 -0500
Date: Tue, 11 Dec 2007 21:37:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 4/4] Move Kconfig.instrumentation to arch/Kconfig and
 init/Kconfig
Message-Id: <20071211213735.fbf67758.akpm@linux-foundation.org>
In-Reply-To: <20071208153935.058016100@polymtl.ca>
References: <20071208153255.078261362@polymtl.ca>
	<20071208153935.058016100@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Dec 2007 10:32:59 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> +config OPROFILE
> +	tristate "OProfile system profiling (EXPERIMENTAL)"
> +	depends on PROFILING && !UML
> +	depends on HAVE_OPROFILE

And I removed the !UML here.  UML shouldn't be setting HAVE_OPROFILE.
