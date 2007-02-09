Return-Path: <linux-kernel-owner+w=401wt.eu-S1423344AbXBIWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423344AbXBIWRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423347AbXBIWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:17:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423344AbXBIWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:17:22 -0500
Subject: Re: NAK new drivers without proper power management?
From: Arjan van de Ven <arjan@infradead.org>
To: nigel@nigel.suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1171058269.1484.64.camel@nigel.suspend2.net>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 09 Feb 2007 23:17:13 +0100
Message-Id: <1171059433.8675.195.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
> Hi.
> 
> I don't think this is already done (feel free to correct me if I'm
> wrong)..
> 
> Can we start to NAK new drivers that don't have proper power management
> implemented? There really is no excuse for writing a new driver and not
> putting .suspend and .resume methods in anymore, is there?


to a large degree, a device driver that doesn't suspend is better than
no device driver at all, right?
now.. if you want to make the core warn about it, that's very fair

