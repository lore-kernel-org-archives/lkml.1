Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbXLTWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbXLTWWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765597AbXLTWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:21:50 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:57138 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765433AbXLTWVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:21:49 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH 0/4] add task handling notifier
Date: Thu, 20 Dec 2007 23:25:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <476A780C.76E4.0078.0@novell.com>
In-Reply-To: <476A780C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712202325.14922.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

I like and support your idea!

On Thursday 20 December 2007, Jan Beulich wrote:
> With more and more sub-systems/sub-components leaving their footprint
> in task handling functions, it seems reasonable to add notifiers that
> these components can use instead of having them all patch themselves
> directly into core files.

Yes, but why export variables? Wouldn't it be better to export 
an API? 

That simplifies the callers (they all pass "current" as task 
and "task_notifier_list" as arguments).

It also prevents exposing internal variables (notifier lists 
ARE internal variables) to modules.

What do you think?


Best Regards

Ingo Oeser
