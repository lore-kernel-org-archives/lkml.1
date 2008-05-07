Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYEGMr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYEGMr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEGMrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:47:04 -0400
Received: from saeurebad.de ([85.214.36.134]:35426 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866AbYEGMrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:47:01 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/3] Rename WARN() to WARNING() to clear the namespace
References: <20080506232017.247001e0@infradead.org>
Date: Wed, 07 May 2008 14:46:53 +0200
In-Reply-To: <20080506232017.247001e0@infradead.org> (Arjan van de Ven's
	message of "Tue, 6 May 2008 23:20:17 -0700")
Message-ID: <87r6cecmde.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Arjan van de Ven <arjan@infradead.org> writes:

> Subject: Rename WARN() to WARNING() to clear the namespace
> From: Arjan van de Ven <arjan@linux.intel.com>
>
> We want to use WARN() as a variant of WARN_ON(), however
> a few drivers are using WARN() internally. This patch renames
> these to WARNING() to avoid the namespace clash.
> A few cases were defining but not using the thing, for those
> cases I just deleted the definition.

It always bugged me that there is no WARN() that behaves similar to
BUG().

What do you think of making WARN() just emit the warning
unconditionally?

And maybe add the possibility to emit a text as well on both WARN() and
BUG()?  BUG("my kitten was hit by page %p!\n", page);

	Hannes
