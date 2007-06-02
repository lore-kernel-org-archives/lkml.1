Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbXFBRtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbXFBRtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbXFBRtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:49:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760556AbXFBRtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:49:05 -0400
Date: Sat, 2 Jun 2007 10:48:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>
Subject: Re: Conditionals for development tests and output
Message-Id: <20070602104821.d2d8d668.akpm@linux-foundation.org>
In-Reply-To: <20070602144348.GD5500@stusta.de>
References: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com>
	<20070602144348.GD5500@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 16:43:48 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> And your approach could easily result in code paths never tested in 
> -mm or -rc kernels exploding in the actual release.

yep, we need to ensure that DEVELKERNEL gets turned off a few weeks
before final release.
