Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXAVT4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXAVT4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXAVT4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:56:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXAVT4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:56:21 -0500
Date: Mon, 22 Jan 2007 11:56:13 -0800
From: Andrew Morton <akpm@osdl.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] How to (automatically) find the correct maintainer(s)
Message-Id: <20070122115613.07966c2d.akpm@osdl.org>
In-Reply-To: <45A9092F.7060503@student.ltu.se>
References: <45A9092F.7060503@student.ltu.se>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 13 Jan 2007 17:30:39 +0100 Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Would like to come with a suggestion I have been wondering about for a 
> while, why not add the config-flag, used in Kconfig/Makefile in the 
> MAINTAINERS-file?

I find that the most practical way to find out who really maintains a
driver is to run git-whatchanged on it and see who has been doing stuff to
it.

