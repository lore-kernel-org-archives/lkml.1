Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYELNDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYELNDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbYELNCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:02:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:51895 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYELNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tawKu5dVQvc+INqep2NGG7DautfwxoQRiWQGY3i3ikG6pFvYZkDSJ33/YbPFOESTx1EaslyO/wNqnCS3Rwc9iP1tmnoqfjQ0YTDhs5DmCvFsVbRkMz7sayHLjf6VyZWBLCMScvtPXV3vaFN0fUp4F+gN+2WpWWF0OHrh6gHcJuw=
Message-ID: <8bd0f97a0805120602n367099a9j3b1b0a8f801877e6@mail.gmail.com>
Date: Mon, 12 May 2008 09:02:42 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 4/4] [MM/NOMMU]: Export two symbols in nommu.c for mmap test
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dwmw2@infradead.org, "Vivi Li" <vivi.li@analog.com>
In-Reply-To: <20080512130058.GA8981@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-5-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0805120338l1d7e0e7eiffebae3bf33c172c@mail.gmail.com>
	 <20080512130058.GA8981@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 9:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Yeah, even the url pointer to there is totally unreadable.  I still
> don't understand why you want to export this symbols.  Also please make
> sure to always submit the code actually using the exports in the same
> patchkit, that makes it a lot easier to figure.

the symbols are exported for MMU already.  this brings the no-MMU code in line.
-mike
