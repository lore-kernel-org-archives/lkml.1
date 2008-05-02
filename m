Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbYEBHIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbYEBHIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbYEBHH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:07:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8171 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbYEBHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=h775p3Gt8m+IYexGfgAQJMbxEBuIvLK5A5ogOvvIN89X4IYLvDYCNKXaNlKxT3XHxU6NyTV1sQDuR88Ex6bAzUeaGIT1sZISsPnDHAyU1SAUM6TxlSR1xIEclwFuqr/P6pvZsGQVc8ImJwIl8wsrbX8uZwkG0JdVZ8CKG/n+eFw=
Message-ID: <ed10ee420805020007x6e001a44o49f486a18ce3e554@mail.gmail.com>
Date: Fri, 2 May 2008 00:07:54 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 07/11] kobject: do not copy vargs, just pass them around
Cc: linux-kernel@vger.kernel.org, "Kay Sievers" <kay.sievers@vrfy.org>
In-Reply-To: <1209599870-22919-7-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430235701.GA20981@suse.de>
	 <1209599870-22919-7-git-send-email-gregkh@suse.de>
X-Google-Sender-Auth: 2573f8ec04b4cd65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/08, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
>
>  This prevents a few unneeded copies.

That's a horrible title for what this obviously correct patch does, but I
suppose it's way too late now.

s/just pass them around/just use them/

-sb
