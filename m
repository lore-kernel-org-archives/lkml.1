Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYAPQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYAPQbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYAPQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:31:26 -0500
Received: from saeurebad.de ([85.214.36.134]:58466 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbYAPQb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:31:26 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Why is the kfree() argument const?
Date: Wed, 16 Jan 2008 17:32:23 +0100
Message-ID: <87lk6pvii0.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any reason why kfree() takes a const pointer just to degrade it
with the call to slab_free()/__cache_free() again?  The promise that the
pointee is not modified is just bogus in this case, anyway, isn't it?

	Hannes
