Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZLDMYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZLDMYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZLDMYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:24:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47134 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756231AbZLDMYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:24:30 -0500
Date: Fri, 4 Dec 2009 12:26:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Graham Murray <gmurray@webwayone.co.uk>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: 2.6.32 CONFIG_SX marked as BROKEN
Message-ID: <20091204122638.597d30b5@lxorguk.ukuu.org.uk>
In-Reply-To: <7wd42vyp2i.fsf@webwayone.co.uk>
References: <7wd42vyp2i.fsf@webwayone.co.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Dec 2009 11:08:05 +0000
Graham Murray <gmurray@webwayone.co.uk> wrote:

> Commit 412145947adfca60a4b5b4893fbae82dffa25edd marked CONFIG_SX as
> Broken. The commit comments state that there are no users. We are using
> SX cards in production servers. I discovered this when I attempted to
> upgrade a development server to 2.6.32 and it failed to find the cards.

The original long discussion with the patch was intentionally trimmed for
the kernel submit. They were marked broken not just because we could find
no users but also because the code in the kernel has some very serious
flaws which I was able to demonstrate are exploitable.

Had it merely sucked it wouldn't have been marked as broken.

The bigger problem is that the design of the ancient midlayer gs code it
uses is so broken that it really needs a major rework or the sx driver
extracting from it completely. Both are major bits of work.

Alan


