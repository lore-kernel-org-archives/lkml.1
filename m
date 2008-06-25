Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYFYO0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYFYO0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYFYO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:26:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45697 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFYO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:26:20 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20080625141054.GB20851@kernel.dk> (message from Jens Axboe on
	Wed, 25 Jun 2008 16:10:54 +0200)
Subject: Re: generic_file_splice_read() issues
References: <E1KBVRu-0005y4-1i@pomaz-ex.szeredi.hu> <20080625141054.GB20851@kernel.dk>
Message-Id: <E1KBVwv-0006De-6e@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Jun 2008 16:26:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps we can abstract that bit out into a small helper function, tied
> in with your previous patch.

If you don't mind, I'd leave this to you.  I don't have the means (and
time) to test these changes, and anyway my preferred solution to all
known and unknown problems of generic_file_splice_read() would be to
move it to do_generic_file_read(), which you and Linus unfortunately
don't like :/

Miklos
