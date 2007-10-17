Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXJQU7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXJQU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXJQU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:59:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288AbXJQU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:59:03 -0400
Date: Wed, 17 Oct 2007 16:58:57 -0400
From: Rik van Riel <riel@redhat.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: VM question - accounting of SysV SHM
Message-ID: <20071017165857.08b887e9@bree.surriel.com>
In-Reply-To: <75b66ecd0710171349n2a2a5922qfc0d8bb64980a15c@mail.gmail.com>
References: <75b66ecd0710171349n2a2a5922qfc0d8bb64980a15c@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 16:49:07 -0400
"Lee Revell" <rlrevell@joe-job.com> wrote:

> Sorry to ask this question on the list but I've Googled and found
> nothing.
> 
> Is system V shared memory accounted for as Cached, or as normal
> application memory?

Cached.

Shared memory segments basically are tmpfs files.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
