Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbYAUXYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbYAUXYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbYAUXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:22:05 -0500
Received: from ozlabs.org ([203.10.76.45]:57063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761980AbYAUXWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:22:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] add module taint on ndiswrapper
Date: Tue, 22 Jan 2008 10:21:12 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, jcm@jonmasters.org
References: <20080121204341.GA29679@dallas.jonmasters.org>
In-Reply-To: <20080121204341.GA29679@dallas.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221021.12984.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 07:43:41 Jon Masters wrote:
> The struct module taints member is supposed to store per-module taint
> data. The kernel knows about certain specific external modules that will
> taint the kernel, such as ndiswrapper. Use of ndiswrapper possibly
> should set the per-module taint in addition to the global kernel
> taint flag, unless we're arguing not because wrapper module itself
> is not what actually causes the kernel to be tainted as such?
>
> Signed-off-by: Jon Masters <jcm@jonmasters.org>

Thanks, applied.

Rusty.
