Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYANW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYANW2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbYANWUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:20:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:49910 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbYANWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TnDXdX+8SUJclTakykHrvJnSs9CN50zlUmbpCGWIjbkmLh0P/wpuAx3loN7MvZOYnmdmsv+RT1jnYfsLosSJw/AvxaSJMj49hM5wqv/TUD6C/5UyK98n5aTQYr0PwkZ8CP7ZicK4f6xPgKEILk3pD0Rg60QsL+AY7vDsLpdB2H8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Date: Mon, 14 Jan 2008 23:32:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de> <200801142250.58201.bzolnier@gmail.com>
In-Reply-To: <200801142250.58201.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801142332.58341.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 13 January 2008, Borislav Petkov wrote:
> > ..and replace them with flag enums.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

small update:

PC_ABORT is never set and may as well be removed in a pre-patch
