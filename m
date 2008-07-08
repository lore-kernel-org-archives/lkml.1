Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYGHJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYGHJcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYGHJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:32:10 -0400
Received: from ozlabs.org ([203.10.76.45]:37490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGHJcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:32:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] lguest: fix switcher_page leak on unload
Date: Tue, 8 Jul 2008 19:31:54 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <87r6a4n5hl.fsf@saeurebad.de>
In-Reply-To: <87r6a4n5hl.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081931.54647.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 18:29:42 Johannes Weiner wrote:
> map_switcher allocates the array, unmap_switcher has to free it
> accordingly.

Applied, thanks Johannes!  A small mem leak on module remove probably isn't 
worth sending for -rc9, but queued for next merge.

Cheers,
Rusty.
