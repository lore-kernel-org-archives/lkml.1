Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZAJAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZAJAiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZAJAiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:38:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZAJAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:38:03 -0500
Date: Fri, 9 Jan 2009 16:37:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mikew@google.com,
       rohitseth@google.com, linux-api@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH]Fix: 32bit binary has 64bit address of stack vma
Message-Id: <20090109163725.11294fb1.akpm@linux-foundation.org>
In-Reply-To: <604427e00901091627n7c909abt6aa1f01c181ad65d@mail.gmail.com>
References: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com>
	<604427e00901081840pa6dcc41u9a7a5c69302c7b60@mail.gmail.com>
	<604427e00901091627n7c909abt6aa1f01c181ad65d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 16:27:07 -0800
Ying Han <yinghan@google.com> wrote:

> friendly ping...

We'll get there.  We're in the merge window now, so I tend to defer
non-serious bugfixes until things are a bit quieter.

> On Thu, Jan 8, 2009 at 6:40 PM, Ying Han <yinghan@google.com> wrote:
> > On Mon, Jan 5, 2009 at 3:39 PM, Ying Han <yinghan@google.com> wrote:
> >> From: Ying Han <yinghan@google.com>
> >>
> >> Fix 32bit binary get 64bit stack vma offset.
> >>
> >> 32bit binary running on 64bit system, the /proc/pid/maps shows for the
> >> vma represents stack get a 64bit adress:
> >> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]

That changelog hurts my brain.

> >> Signed-off-by:  Ying Han <yinghan@google.com>
