Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZDMJcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZDMJcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZDMJcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:32:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZDMJcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:32:35 -0400
Date: Mon, 13 Apr 2009 05:32:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Felix Blyakher <felixb@sgi.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, kernel-janitors@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jeff@garzik.org,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [PATCH 56/56] xfs: Remove void casts
Message-ID: <20090413093232.GA14320@infradead.org>
References: <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-57-git-send-email-jwjstone@fastmail.fm> <81C20178-5096-4E2E-A588-28AAE674748F@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81C20178-5096-4E2E-A588-28AAE674748F@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 12:37:08PM -0500, Felix Blyakher wrote:
>
> On Apr 8, 2009, at 6:22 AM, Jack Stone wrote:
>
>> Remove uneeded void casts
>>
>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>
> See comments below.

Agree with the comments, als the subject line seems wrong, the patch
doesn't remove void casts, but casts from a void pointer to a typed
one which aren't nessecary.

Also please don't submit patches like this in a large series to the
world but separately to the listed maintainer / mailinglist of each
subsystem as there is no interdependency nor a general interest.

