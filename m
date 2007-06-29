Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXF2CCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXF2CCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXF2CCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:02:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764893AbXF2CCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:02:09 -0400
Date: Thu, 28 Jun 2007 19:01:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Joshua Wise <jwise@google.com>, linux-kernel@vger.kernel.org,
       thockin@google.com, mikew@google.com, masouds@google.com
Subject: Re: [PATCH] Info dump on Oops or panic()
Message-Id: <20070628190146.64af724a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706290237390.31463@twin.jikos.cz>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
	<Pine.LNX.4.64.0706290237390.31463@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 02:39:33 +0200 (CEST) Jiri Kosina <jikos@jikos.cz> wrote:

> On Thu, 28 Jun 2007, Joshua Wise wrote:
> 
> >  This patch adds a call chain to be invoked when the system oopses or
> >  panics. 
> 
> That seems really fragile, processing a callchain when the system goes to 
> panic is not guaranteed to work. Wouldn't simple function call have higher 
> chances of survival?

That was my complaint, but then we remembered die_chain, which is already
doing that.

Joshua will take a look at using die_chain instead of adding another one.

