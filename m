Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXH1N5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXH1N5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXH1N5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:57:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45749 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbXH1N5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:57:39 -0400
Date: Tue, 28 Aug 2007 06:57:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] i386: unexport machine_id
Message-ID: <20070828065706.50a3eba4@laptopd505.fenrus.org>
In-Reply-To: <20070828010741.19fccb06.akpm@linux-foundation.org>
References: <20070827212808.GT4121@stusta.de>
	<20070828010741.19fccb06.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 01:07:41 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> You know my position on removal of exports with no warning.

I know it (and don't quite agree but ok)
> 
> If the relevant maintainer chooses to apply the patch then ho hum I
> have other things to think about.  Your best shot at getting this
> sort of thing merged would be to cc the appropriate maintainer.
> 
> Or, better, use __deprecated_for_modules.  That's what it was added
> for. -

and/or use EXPORT_UNUSED_SYMBOL so that people at least have the option
to not suffer the overhead *now*.
