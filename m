Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbYBWIE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbYBWIE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbYBWIDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:03:40 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757852AbYBWIDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:03:37 -0500
Date: Sat, 23 Feb 2008 00:02:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 0/8]: uninline & uninline
Message-Id: <20080223000220.e9229c99.akpm@linux-foundation.org>
In-Reply-To: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:47:10 +0200 "Ilpo J__rvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> Ok, here's the top of the list (10000+ bytes):

This is good stuff - thanks.

> -41525  2066 f, 3370 +, 44895 -, diff: -41525  IS_ERR 

This is a surprise.  I expect that the -mm-only
profile-likely-unlikely-macros.patch is the cause of this and mainline
doesn't have this problem.

If true, then this likely/unlikely bloat has probably spread into a lot of
your other results and it all should be redone against mainline, sorry :(

(I'm not aware of anyone having used profile-likely-unlikely-macros.patch
in quite some time.  That's unfortunate because it has turned up some
fairly flagrant code deoptimisations)
