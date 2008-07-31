Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYGaAmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYGaAmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYGaAmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:42:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33570 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYGaAmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:42:31 -0400
Date: Thu, 31 Jul 2008 01:42:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
Message-ID: <20080731004214.GA32207@shareable.org>
References: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <20080731001131.GA30900@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731001131.GA30900@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> not being able to tell when a sendfile() has finished with the pages
> its sending.

(Except by the socket fully closing or a handshake from the other end,
obviously.)

-- Jamie
