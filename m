Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZDOT1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZDOT1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZDOT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:27:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbZDOT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:27:11 -0400
Date: Wed, 15 Apr 2009 12:22:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@elte.hu, x86@kernel.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
 warnings
Message-Id: <20090415122251.beba3b43.akpm@linux-foundation.org>
In-Reply-To: <1239793458.7653.12.camel@ht.satnam>
References: <1239793458.7653.12.camel@ht.satnam>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 16:34:18 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> I added -Werror for x86/files only

yikes.

Not only does this need to be tested for all configs, it also need to
be tested for all approved gcc versions.

For example, one of my compilers always spews warnings from x86 because
it has the "foo(&bar) doesn't initialise bar" stupidity.

And there will be other gcc inconsitencies, for sure.

> Subject: [PATCH-tip] x86: Adding -Werror to arch/x86/ files only for !CONFIG_ALLOW_X86_WARNINGS

whew, that sounds better.

