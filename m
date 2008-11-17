Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYKQNrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYKQNrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYKQNrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:47:24 -0500
Received: from lazybastard.de ([212.112.238.170]:47778 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYKQNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:47:23 -0500
Date: Mon, 17 Nov 2008 14:47:13 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/7] Improve alloc_percpu: expose percpu_modalloc and percpu_modfree
Message-ID: <20081117134713.GA8949@logfs.org>
References: <20081117132630.AC29EDDDFF@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081117132630.AC29EDDDFF@ozlabs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 November 2008 13:28:32 +0000, Rusty Russell wrote:
> +static inline void *percpu_modalloc(unsigned long size, unsigned long align)
> +{
> +	return kzalloc(size);
> +}

You didn't test the patches much, did you? :)

Jörn

-- 
This above all: to thine own self be true.
-- Shakespeare
