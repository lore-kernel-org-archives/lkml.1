Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXHNSBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXHNSBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764966AbXHNSBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:01:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762596AbXHNSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:01:16 -0400
Subject: Re: System call interposition/unprotecting the table
From: Arjan van de Ven <arjan@infradead.org>
To: Hajime Inoue <hinoue@ccsl.carleton.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <46C1E5F5.9050702@ccsl.carleton.ca>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
	 <20070814000956.7c8929dd@the-village.bc.nu>
	 <46C1E5F5.9050702@ccsl.carleton.ca>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 14 Aug 2007 10:57:38 -0700
Message-Id: <1187114259.2618.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Just protecting the table does not stop rootkits. 

not in general no; however it requires more rights than before (eg code
execute rather than just "write to memory")

> Why isn't the rest of the kernel code protected along with the table?

it is if you set the right config options.


