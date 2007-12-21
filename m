Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbXLUHga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbXLUHga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXLUHgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:36:23 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31604
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbXLUHgW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:36:22 -0500
Message-Id: <476B7B18.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 21 Dec 2007 07:36:40 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Oeser" <ioe-lkml@rameria.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] add task handling notifier
References: <476A780C.76E4.0078.0@novell.com>
 <200712202325.14922.ioe-lkml@rameria.de>
In-Reply-To: <200712202325.14922.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Yes, but why export variables? Wouldn't it be better to export 
>an API? 
>
>That simplifies the callers (they all pass "current" as task 
>and "task_notifier_list" as arguments).
>
>It also prevents exposing internal variables (notifier lists 
>ARE internal variables) to modules.
>
>What do you think?

Would be a simple change if the concept itself is generally welcome. Will
first see whether I get other comments requiring re-work.

Jan

