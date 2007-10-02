Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXJBPcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXJBPcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXJBPcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:32:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51961 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbXJBPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:32:24 -0400
Date: Tue, 2 Oct 2007 08:28:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kirill Korotaev <dev@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] mark read_crX() asm code as volatile
Message-ID: <20071002082856.3c478e66@laptopd505.fenrus.org>
In-Reply-To: <470250E0.5090706@openvz.org>
References: <470250E0.5090706@openvz.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 18:08:32 +0400
Kirill Korotaev <dev@openvz.org> wrote:

> Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from
> gentoo) can generate incorrect code with read_crX()/write_crX()
> functions mix up, due to cached results of read_crX().
> 

I'm not so sure volatile is the right answer, as compared to giving the
asm more strict contraints....

asm volatile tends to mean something else than "the result has
changed"....

