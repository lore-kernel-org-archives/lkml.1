Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJUUmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJUUmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYJUUmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:42:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYJUUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:42:08 -0400
Date: Tue, 21 Oct 2008 13:41:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: orenl@cs.columbia.edu, torvalds@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org, tglx@linutronix.de,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
 restart
Message-Id: <20081021134133.f84151e9.akpm@linux-foundation.org>
In-Reply-To: <20081021202410.GA10423@us.ibm.com>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	<1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>
	<20081021124130.a002e838.akpm@linux-foundation.org>
	<20081021202410.GA10423@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 15:24:10 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> > I'd like to see the security guys take a real close look at all of
> > this, and for them to do that effectively they should be provided with
> > a full description of the security design of this feature.
> 
> Right, some of the above should be spelled out somewhere.  Should it be
> in the patch description, in the Documentation/checkpoint.txt file,
> or someplace else?

Dupliction is usually bad.  Documentation/checkpoint.txt would be good
(although these things tend to go out of date fast).

If you go that way, please ensure that the documentation patch is early
in the series and that the changelog says "look in here before whining,
dummy".

