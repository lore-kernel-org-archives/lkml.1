Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXF2Ajr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXF2Ajr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763647AbXF2Ajj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:39:39 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50290 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763876AbXF2Ajj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:39:39 -0400
Date: Fri, 29 Jun 2007 02:39:33 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Joshua Wise <jwise@google.com>
cc: linux-kernel@vger.kernel.org, akpm@google.com, thockin@google.com,
       mikew@google.com, masouds@google.com
Subject: Re: [PATCH] Info dump on Oops or panic()
In-Reply-To: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
Message-ID: <Pine.LNX.4.64.0706290237390.31463@twin.jikos.cz>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Joshua Wise wrote:

>  This patch adds a call chain to be invoked when the system oopses or
>  panics. 

That seems really fragile, processing a callchain when the system goes to 
panic is not guaranteed to work. Wouldn't simple function call have higher 
chances of survival?

-- 
Jiri Kosina
