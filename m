Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYFGTq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYFGTq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYFGTqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:46:19 -0400
Received: from 1wt.eu ([62.212.114.60]:1523 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYFGTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:46:18 -0400
Date: Sat, 7 Jun 2008 21:46:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wrong hardlink count in /proc
Message-ID: <20080607194604.GH5609@1wt.eu>
References: <20080607193424.GA25998@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607193424.GA25998@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 03:34:24PM -0400, Dave Jones wrote:
> In 2.6.25, 'find /proc/ -name foo' will print out ..
> 
> find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> in your filesystem driver.  Automatically turning on find's -noleaf
> option.  Earlier results may have failed to include directories that
> should have been searched.

I also encountered this one. I think it is the one which 2.6.25.6 stable
patch 42/50 fixes.

Willy

