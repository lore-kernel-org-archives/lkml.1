Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbXBDN5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbXBDN5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXBDN5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:57:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46711 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXBDN5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:57:33 -0500
Subject: Re: mm: how to check for kernel pages
From: Arjan van de Ven <arjan@infradead.org>
To: Michal Hocko <mstsxfx@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070204110256.GA10477@curandero.marconia.cz>
References: <20070204110256.GA10477@curandero.marconia.cz>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 04 Feb 2007 14:57:30 +0100
Message-Id: <1170597450.3073.1127.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 12:02 +0100, Michal Hocko wrote:
> Hi,
> is there any effective and fast way how to find out whether page
> given by its page frame number is currenly used by (mapped by) kernel?

what do you want to use this for? The answer to your question greatly
depends on that...

Specifically, do you want to know if it's a kernel allocated page or a
kernel mapped page? (Those are different concepts)
Also can you deal with false negatives/positives?


