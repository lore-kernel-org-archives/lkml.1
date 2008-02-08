Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbYBHRtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbYBHRtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYBHRtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:49:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43556 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724AbYBHRtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:49:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Guillaume Chazarain" <guichaz@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       ebiederm@xmission.com, mingo@elte.hu, oleg@tv-sign.ru, rjw@sisk.pl,
       roland@redhat.com, xemul@openvz.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 019/233] proc: fix the threaded /proc/self
References: <200802081218.m18CIHEx023631@imap1.linux-foundation.org>
	<3d8471ca0802080554pfecb2v32dcb8ece0da346a@mail.gmail.com>
Date: Fri, 08 Feb 2008 10:47:08 -0700
In-Reply-To: <3d8471ca0802080554pfecb2v32dcb8ece0da346a@mail.gmail.com>
	(Guillaume Chazarain's message of "Fri, 8 Feb 2008 14:54:51 +0100")
Message-ID: <m1ve4zbasj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Guillaume Chazarain" <guichaz@gmail.com> writes:

> On Feb 8, 2008 1:18 PM,  <akpm@linux-foundation.org> wrote:
>> Long ago when the CLONE_THREAD support first went it someone thought it
>> would be wise to point /proc/self at /proc/<tgid> instead of /proc/<pid>.
>
> The last message about this conversation is:
>
> http://lkml.org/lkml/2007/12/1/172
>
> So I thought we would end up with a new file, in order to make the
> change discoverable.

Yes.  The above patch really is wrong.  There is at least one corner
case in procps that cares.

Andrew my apologies.  I noticed this earlier but forgot to ask you to
remove this from your tree.

Eric
