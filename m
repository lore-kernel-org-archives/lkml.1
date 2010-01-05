Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084Ab0AENdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0AENdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382Ab0AENdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:33:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:34231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0AENdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:33:36 -0500
Date: Tue, 5 Jan 2010 05:36:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105053606.22226880@infradead.org>
In-Reply-To: <20100105053443.4a43fc18@infradead.org>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
	<20100104174308.0790757c@infradead.org>
	<20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
	<20100105053443.4a43fc18@infradead.org>
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

On Tue, 5 Jan 2010 05:34:43 -0800
Arjan van de Ven <arjan@infradead.org> wrote:
> 
> this one is ... interesting btw... I have trouble myself finding where
> the check is done... so I can understand gcc having trouble too.

hmm I guess that's just because it's 5:30am here .. at 5:35am I do see
it.

Wonder if on x86 the function gets inlined, at which point gcc sees the
check, while on s390 it doesn't ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
