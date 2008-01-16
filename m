Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbYAPIxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbYAPIxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYAPIwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:52:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYAPIwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:52:51 -0500
Date: Wed, 16 Jan 2008 00:52:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Bryn Reeves <breeves@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 04/27] kill filp_open()
Message-Id: <20080116005200.0165dc67.akpm@linux-foundation.org>
In-Reply-To: <20071101230831.904FDE9A@kernel>
References: <20071101230826.9A4F6E00@kernel>
	<20071101230831.904FDE9A@kernel>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 16:08:31 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:

> Replace all callers with open_namei() directly, and move the
> nameidata stack allocation into open_namei().

ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch
is using filp_open() and hence doesn't work very well.

A shall revert dm-loop.patch and run away.
