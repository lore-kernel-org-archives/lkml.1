Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531Ab0ARQbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0ARQbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389Ab0ARQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:31:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:40182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0ARQbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:31:39 -0500
Date: Mon, 18 Jan 2010 08:31:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
 patching without stop_machine
Message-ID: <20100118083129.675edb83@infradead.org>
In-Reply-To: <4B548562.6030008@redhat.com>
References: <cover.1263247113.git.jbaron@redhat.com>
	<a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>
	<1263483139.28171.3857.camel@gandalf.stny.rr.com>
	<4B4F3A1A.2030906@zytor.com>
	<20100117185539.GF9008@Krystal>
	<20100117111608.35a98ee2@infradead.org>
	<4B548562.6030008@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 10:59:30 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Yeah, so in the latest patch, I updated it to use int3 even if
> len == 1. :-)
> 


int3 is not making a difference for your case; there is no guarantee
that the other processor even sees the "int3 inbetween state" at all;
if it's not safe without int3 then it won't be safe with int3 either.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
