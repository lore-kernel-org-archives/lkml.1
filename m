Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbYA0Tgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbYA0Tgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYA0Tci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYA0TcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=unQesASJ05FF8wg1TYXd0a/ATckI11UmknXNVDoELy4LeM1a0J1h2zoYi/skt9WTdR95bKEGB1ajSOvF+LsN5Ayg//aSz8H/d53v1mJD3ifqnHEbTM8tsP9q/e6XYRBRyk6CesdYPRsdnstdQ+DT6fbfZW52tzGWTKyG0fqFk54=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 24/32] ide-tape: remove unreachable code chunk
Date: Sun, 27 Jan 2008 20:41:52 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-19-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-19-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801272041.52818.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> tape->speed_ctl is set to 1 in idetape_setup(), but, in calculate_speeds() its
> value is tested for being 0, 1, or 2. Remove the if-branches where
> tape->speed_ctl != 1 since they are never executed.
> 
> Also, rename calculate_speeds() by adding driver's prefix as is with the other
> function names.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

This change is fine but it seems to depend on "ghost" patch #23. ;)

Please move it near the beginning of the series when resubmitting.

Thanks,
Bart
