Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbYEWAlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbYEWAlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbYEWAk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:40:56 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36850 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757885AbYEWAkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:40:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jiDGP0cEskBF3vykpGr0gnYGkxm8x4Iw7Z2nJH3XvNASl1T+T8BMUeuHZQralwvxtPyElNxHDZO4YOL4hdFd3sIu7hjdh8wBUsL3rZerbYQDX6E8+dI3L3pQBM81kJ4fYfMEVYG4Iu6pSpgvzVqozEi8F8qMqbpAs+WJZWVF1fg=  ;
X-YMail-OSG: qE60BFwVM1naNZ0NauYCKEHS2y0K8xDpnBU..IprdSxy.W5Ls5ckvkWDJ.7ZcXNBQ4cVtAohDlJWS_dILeP443NbQHf6N7Zmve9UqXErdMZgIduICpKu2nWKPFlQLGrQG.8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] spi: Push the BKL down into the drivers
Date: Thu, 22 May 2008 17:40:50 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <20080522224509.29ede566@core>
In-Reply-To: <20080522224509.29ede566@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221740.51016.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Alan Cox wrote:
> Another step to removing ->ioctl and to removing the BKL

This happens to not apply with the latest patches; I'll
address that.

Where is the writeup about exactly what lock_kernel() is
supposed to have been protecting against in ioctl code?

- Dave

