Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYAJPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYAJPmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYAJPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:42:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYAJPmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:42:00 -0500
Date: Thu, 10 Jan 2008 10:41:55 -0500
From: Rik van Riel <riel@redhat.com>
To: "Mike Snitzer" <snitzer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080110104155.34b5cede@bree.surriel.com>
In-Reply-To: <170fa0d20801092039w22584e2fw6821e70157f55cae@mail.gmail.com>
References: <20080108205939.323955454@redhat.com>
	<170fa0d20801092039w22584e2fw6821e70157f55cae@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 23:39:02 -0500
"Mike Snitzer" <snitzer@gmail.com> wrote:

> How much trouble am I asking for if I were to try to get your patchset
> to fly on a fairly recent "stable" kernel (e.g. 2.6.22.15)?  If
> workable, is such an effort before it's time relative to your TODO?

Quite a bit :)

The -mm kernel has the memory controller code, which means the
mm/ directory is fairly different.  My patch set sits on top
of that.

Chances are that once the -mm kernel goes upstream (in 2.6.25-rc1),
I can start building on top of that.

OTOH, maybe I could get my patch series onto a recent 2.6.23.X with
minimal chainsaw effort.

> I see that you have an old port to a FC7-based 2.6.21 here:
> http://people.redhat.com/riel/vmsplit/
> 
> Also, do you have a public git repo that you regularly publish to for
> this patchset?  If not a git repo do you put the raw patchset on some
> http/ftp server?

Up to now I have only emailed out the patches. Since there is demand
for them to be downloadable from somewhere, I'll also start putting
them on http://people.redhat.com/riel/

-- 
All rights reversed.
