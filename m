Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbYBHRaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbYBHRaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYBHR3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:29:55 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47829 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443AbYBHR3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:29:54 -0500
Date: Fri, 8 Feb 2008 18:30:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: rubini@vision.unipv.it, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: ifdef KMOD, saving some bytes probably
Message-ID: <20080208173000.GB26183@uranus.ravnborg.org>
References: <47AC87CE.2060200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC87CE.2060200@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 05:48:14PM +0100, Jiri Olsa wrote:
> found some code in misc.c that could be ifdef'ed for KMOD
> 
We need very good arguments in order to introduce
#ifdef/#endif in code.
So this patch needs to come with hard fatcs about .text
savings and where it matters.

	Sam
