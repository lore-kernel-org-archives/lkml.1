Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZE0V0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZE0V0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbZE0V03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:26:29 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44328 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZE0V02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <20090526152540.GA28341@sepie.suse.cz>
References: <20090526152540.GA28341@sepie.suse.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 May 2009 23:26:12 +0200
Message-ID: <ac3eb2510905271426m7ef228aq2c86940ee8a727bb@mail.gmail.com>
Subject: Re: [PATCH] kbuild: generate modules.builtin
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 17:25, Michal Marek <mmarek@suse.cz> wrote:
> To make it easier for tools like mkinitrd to detect whether a needed
> module is missing or whether it is compiled into the kernel, install a
> modules.builtin file listing all modules built into the kernel. This is
> done by generating an alternate config file with all tristate =y options
> set to =Y and reading the makefiles with this config included. The built
> in modules then appear in obj-Y.

That looks very useful.

We like to have that for modprobe not to throw an error if a "module"
is already in the kernel, because it is compiled in. Only modules with
parameters show up in /sys/modules/ and they are already handled fine.

Thanks,
Kay
