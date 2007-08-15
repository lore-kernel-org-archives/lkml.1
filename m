Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXHOQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXHOQke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761021AbXHOQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:40:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbXHOQkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:40:24 -0400
Date: Wed, 15 Aug 2007 19:34:27 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>, kiran@scalemp.com,
       shai@scalemp.com
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815173427.GM3406@bingen.suse.de>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com> <20070815163640.GJ3406@bingen.suse.de> <46C3283B.5090804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C3283B.5090804@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we could even make VSMP depend on PARAVIRT, to make it sure it is 
> completely a paravirt client.

That's the right thing to do I think. Remove the existing ifdefs
and hook vsmp in only using paravirt ops.

-Andi
