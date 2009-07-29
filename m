Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZG2UJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZG2UJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZG2UJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:09:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbZG2UJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:09:15 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Niraj kumar <niraj17@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <b82a89170907250722o572e741dq372ab11faf58261@mail.gmail.com>
References: <1248466429.3567.82.camel@localhost>
	 <b82a89170907250722o572e741dq372ab11faf58261@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:08:42 -0400
Message-Id: <1248898122.2597.54.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 19:52 +0530, Niraj kumar wrote:
> >
> > - subtree notification.
> >        Currently to only watch /home and all of it's descendants one must
> > either register a directed watch on every directory or use a global
> > listener.  The global listener with ignored_mask is not as bad as it
> > sounds in my testing, but decent subtree registration and notification
> > would be a big win in a lot of people's mind.
> 
> Unless it's already covered in some way, I would also be interested
> in notification based on "process subtree".  What this means is that
> for whatever notification a particular process requests, it's only
> interested in events generated  by itself and it's children.
> This is useful in doing auditing for file system related access.

Has not been considered.   You'd have to really flesh out the use case
before I could.....

-Eric

