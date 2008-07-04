Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYGDTmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYGDTmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYGDTmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:42:01 -0400
Received: from vena.lwn.net ([206.168.112.25]:58732 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYGDTmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:42:00 -0400
Date: Fri, 4 Jul 2008 13:41:59 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs
 users
Message-ID: <20080704134159.4dd9f74e@bike.lwn.net>
In-Reply-To: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 19:52:16 +0200
Johannes Weiner <hannes@saeurebad.de> wrote:

> +(add-hook 'c-mode-hook
> +          (lambda ()
> +            (let ((filename (buffer-file-name)))
> +              ;; Enable kernel mode for the appropriate files
> +              (when (and file
> +                         (string-match "/usr/src/linux" filename))

Shouldn't that be "(and filename ..." rather than "file"?

A test for /usr/src/linux seems misplaced, though; I don't think a
whole lot of people keep their kernel trees there anymore.  There must
be a better heuristic one can use to figure out whether a kernel source
file is being edited.

jon
