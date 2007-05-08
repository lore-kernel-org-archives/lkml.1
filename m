Return-Path: <linux-kernel-owner+w=401wt.eu-S968460AbXEHWfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968460AbXEHWfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968453AbXEHWfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:35:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51722 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968408AbXEHWfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:35:12 -0400
Date: Wed, 9 May 2007 00:31:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 2/4] add argv_split()
In-Reply-To: <20070508205517.142888645@goop.org>
Message-ID: <Pine.LNX.4.61.0705090029590.2342@yvahk01.tjqt.qr>
References: <20070508205129.064843364@goop.org> <20070508205517.142888645@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 13:51, Jeremy Fitzhardinge wrote:
>+
>+static const char *skip_sep(const char *cp)

These are so simple they could use an 'inline' tag.

>+{
>+	while(*cp && isspace(*cp))
>+		cp++;
>+
>+	return cp;
>+}
>+

>+#ifdef TEST

But not in the end result.

>+int main() {
>+	const char *testvec[] = {

Suggesting static const char *const testvec[].



Jan
-- 
