Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYAORgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYAORgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYAORf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:35:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36493 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYAORf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:35:59 -0500
Date: Tue, 15 Jan 2008 18:39:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Folding _PAGE_PWT into _PAGE_PCD (was Re: unify pagetable accessors patch causes double fault II)
Message-ID: <20080115173902.GB2665@one.firstfloor.org>
References: <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115135317.GA13493@elte.hu> <478CEA82.9010606@goop.org> <20080115172346.GB2377@one.firstfloor.org> <478CEE45.1040006@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CEE45.1040006@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good, but isn't the name _PAGE_CACHE misleading?  Or does it mean 

It's all bits related to caching.

> something else in the context of PAT?

It could mean arbitary things with PAT -- PAT essentially allows to
reprogram these bits freely to various different modi using a mapping table.   
In the default configuration any bit set should resort in a uncacheable mode 
though.

-Andi
