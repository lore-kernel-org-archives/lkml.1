Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZBYV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZBYV4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZBYV4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:56:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199AbZBYV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:56:28 -0500
Date: Wed, 25 Feb 2009 13:54:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       peterz@infradead.org, srostedt@redhat.com
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-Id: <20090225135446.e82ac3ff.akpm@linux-foundation.org>
In-Reply-To: <20090225214018.GB5838@nowhere>
References: <20090225203007.582030664@goodmis.org>
	<20090225203427.382137706@goodmis.org>
	<20090225214018.GB5838@nowhere>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 22:40:19 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Why not expand it to a copy_delimited_from_user() ?
> This way we could use any separator we want, not just spaces.
> We could use one more parameter for the separator and
> copy_work_from_user would be a wrapper above.

hah!  That was quick.

Yes, you could pass in a delimiter string or a pointer to a user-supplier
function (which defaults to isspace() if NULL?) or whatever.  But we can
do that if and when it is needed.
