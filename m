Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYCBSAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYCBSAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYCBSAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:00:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:39318 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYCBSAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=m96nk1B8kBDI7wVuXC83ydm3suZouRQ44OU4tFpyVZltijoS2LVKYypdl+kmx+E9Aubrqt3B8VLCE1Cuq4ZHrJ5oGLSv5cyTxSOedkc/rQ/o2+WWUc5yf97j+w4ityslJOnwO/gXlaWeLiNpLI8zWwFUpyPA92MYI3VLbtees1U=
From: Pawel Plociennik <paplociennik@gmail.com>
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Date: Sun, 2 Mar 2008 18:59:30 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803011409.59526.paplociennik@gmail.com> <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
In-Reply-To: <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021859.30473.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 March 2008 11:00, Guillaume Chazarain wrote:
> Wouldn't booting with 'init=/usr/sbin/chroot /path /sbin/init' achieve
> the same effect?
> Haven't tested it, just wondering.
Hi,

I think that procces which has pid 0 is a special procces because it
removes a *zombie* procceses so it is good to use a *dedicated*
program for it such as a /sbin/init .
/usr/sbin/chroot doesn't remove a *zombie* procceses :-(

Regards,

Pawel Plociennik
