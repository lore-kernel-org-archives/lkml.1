Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZAQLIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZAQLIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 06:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZAQLIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 06:08:41 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55856 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZAQLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 06:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPxtEzNt1OL/uf8SW1NGpqTZTqzRgCdSdP/hYXhxT0HjneE3jynMJPF3ZSoEvJUyET
         r7Di95k9IP5Q3YIVCEFN7+h4XwDu1cIUCULflOBvC2vx+obicE2sJoUDn19LqWfUn6vb
         XsF5l5Rs0hhFJrXTwNyhWhUGAJ8I0MVlrAiaM=
Date: Sat, 17 Jan 2009 12:08:18 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Martin Bligh <mbligh@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, bugme-admin@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bugzilla permissions
Message-ID: <20090117110814.GA10385@joi>
References: <20090113132714.75c9ed96@hyperion.delvare> <33307c790901160935v2495615fo4ee0998d348fa117@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790901160935v2495615fo4ee0998d348fa117@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 09:35:45AM -0800, Martin Bligh wrote:
> Given that there's no real control on bugzilla accounts, I'm somewhat
> reluctant to make it a complete free for all and let any new user edit
> any bug. However, for anyone running a subsystem, or anyone else
> that I have a vague clue who they are (or any established developer
> will vouch for, anyone I can see git commits for, etc), I am perfectly

Couldn't it be automatic?
Pulling once a day, refreshing mail list by:
git shortlog -e -s|sed "s/.*<\([^>]*\)>/\1/"
and wiring it into bugzilla permission system shouldn't be too time consuming...

> willing to enable global edit on a individual basis. Hasn't been a big
> problem up until now, so I suspect it won't turn into one.

Marcin
