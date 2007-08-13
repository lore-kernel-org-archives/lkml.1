Return-Path: <linux-kernel-owner+w=401wt.eu-S1030623AbXHMQm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030623AbXHMQm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968835AbXHMPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:50:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45032 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969781AbXHMPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:50:45 -0400
Subject: Re: [PATCH]: proc: export a processes resource limits via
	proc/<pid>
From: Arjan van de Ven <arjan@infradead.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20070813140044.GB1960@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 13 Aug 2007 08:47:10 -0700
Message-Id: <1187020030.2688.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-13 at 10:00 -0400, Neil Horman wrote:
> Hey there-
> 	Currently, there exists no method for a process to query the resource
> limits of another process.  They can be inferred via some mechanisms but they
> cannot be explicitly determined.  Given that this information can be usefull to
> know during the debugging of an application, I've written this patch which
> exports all of a processes limits via /proc/<pid>/limits.  Tested successfully
> by myself on x86 on top of 2.6.23-rc2-mm1.


since this information, by it's nature, is security sensitive, I would
really really strongly suggest that you make this restricted to those
processes that can ptrace the victim only... (which is basically "same
user or root")

Making this world readable is very much a bad thing to do 

