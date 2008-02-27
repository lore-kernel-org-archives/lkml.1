Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYB0X7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYB0X7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbYB0X6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:58:40 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbYB0X6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:58:38 -0500
Date: Wed, 27 Feb 2008 15:58:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: fix sparse variable shadowing and int as NULL
 pointer in rocket.c
Message-Id: <20080227155836.48d86c12.akpm@linux-foundation.org>
In-Reply-To: <1204155487.20280.20.camel@brick>
References: <1203702419.5962.8.camel@brick>
	<20080227152948.34b6e295.akpm@linux-foundation.org>
	<1204155487.20280.20.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 15:38:07 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> > Probably this code is cleaner than the old version so let's do it, but it
> > seems that we need a general fix.
> 
> min3()?  No _good_ ideas I'm afraid.

Fix sparse, I'd say.  Probably hard to do, but that warning really
isn't useful.
