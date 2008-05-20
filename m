Return-Path: <linux-kernel-owner+w=401wt.eu-S934792AbYETP64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792AbYETP64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbYETP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:58:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbYETP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:58:44 -0400
Date: Tue, 20 May 2008 08:58:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080520085830.22c99115@infradead.org>
In-Reply-To: <20080520152843.CF4181B4205@basil.firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
	<20080520152843.CF4181B4205@basil.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 17:28:43 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Add a new fops entry point to allow fasync without BKL. 

I (again) really don't like having another entry point for this...
it'll stay around forever rather than doing this as one step and 
move on.
