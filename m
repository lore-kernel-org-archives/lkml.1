Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYBFHBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYBFHBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 02:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYBFHAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 02:00:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbYBFHAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 02:00:55 -0500
Date: Tue, 5 Feb 2008 23:00:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-Id: <20080205230044.89cd639b.akpm@linux-foundation.org>
In-Reply-To: <200802060108.31644.dtor@insightbb.com>
References: <200802060108.31644.dtor@insightbb.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 01:08:30 -0500 Dmitry Torokhov <dtor@insightbb.com> wrote:

> Andrew Morton (1):
>       Input: i8042 - non-x86 build fix

Also, please prefer to fold patches like this into the patch which they
fix, to avoid breaking git-bisect, thanks.

(I add a little one-line mention in the changelog so the contributor gets
a nod, and as a record of what happened)
