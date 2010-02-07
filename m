Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0BGGbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 01:31:07 -0500
Received: from tundra.namei.org ([65.99.196.166]:37655 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0BGGbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 01:31:05 -0500
Date: Sun, 7 Feb 2010 17:30:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@us.ibm.com>
cc: Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       serue@linux.vnet.ibm.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ima: avoid null pointer deref in ima_main.c
In-Reply-To: <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
Message-ID: <alpine.LRH.2.00.1002071730220.20842@tundra.namei.org>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com> <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Mimi Zohar wrote:

> Xiaotian Feng <dfeng@redhat.com> wrote on 02/05/2010 05:14:41 AM:
> 
> > I've met following oops when kernel is running ltp test pipe07.
> > Which is trying to open pipes until EMFILE is returned.
> 
> This is a known bug and a patch was posted by J.R Okajima on Dec 29th
> http://lkml.org/lkml/2009/12/29/13.
> 
> James, Al, can we get the patch applied?

Mimi, is this patch correct for Linus' current tree?


-- 
James Morris
<jmorris@namei.org>
