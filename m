Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZKCXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZKCXvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZKCXvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:51:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZKCXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:51:49 -0500
Subject: Re: [PATCH] qlogicpti: add missing parentheses
From: James Bottomley <James.Bottomley@suse.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF0BF04.9030203@gmail.com>
References: <4AF0BF04.9030203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 17:51:49 -0600
Message-Id: <1257292309.2454.54.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 00:38 +0100, Roel Kluin wrote:
> `+' has a higher precedence than `?' so the condition always
> evaluates to true and this is preprocessed to `7*((ql) - 1)'
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/qlogicpti.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This one must be right, I think.

It looks plausible ... but it will increase the mailbox segment length
by 4 ... someone needs to verify that this increase will actually work
and won't run off the end of the mailbox table.

James


