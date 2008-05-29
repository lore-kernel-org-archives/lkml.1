Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYE2SEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYE2SEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYE2SEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:04:34 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:27024 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757422AbYE2SEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:04:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XYHqp0wM1nqwGuJi81SNklTqralcDepriq0UzhQ6gp3xPfx7LcewAZL/VMHOMJRnINVQJfI0JYfIH1BPXIG9tRu/C03mwW/PaW6n+ccN5LukWWi1ZXtzXzesBwf6bLZVNH3BUMi7g7+cfvI+dtLmbIQQ1CW6ydi15Thk8Cxo8yg=  ;
X-YMail-OSG: OKPpGuQVM1kzVYTUjFDejL3ERa70ENOmaR8owtyyltWTS_GcyTfOfOEJ4DqxjJXgmsmZ2f95xZopiYjBKeq3T48Y6er7Jx0UdCZJjAgsGM1pHz_9i6icBqaBwIDpX9J1A38-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] fsl_usb2_udc: fix recursive lock
Date: Thu, 29 May 2008 11:04:30 -0700
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eugene T. Bordenkircher" <Eugene_Bordenkircher@selinc.com>
References: <1212066285-6013-1-git-send-email-leoli@freescale.com>
In-Reply-To: <1212066285-6013-1-git-send-email-leoli@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805291104.30779.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008, Li Yang wrote:
> UDC needs to release lock before calling out to gadget driver, since
> it may need to reenter.  The change fixes kernel BUG observed on rt
> kernel.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... clearly, 2.6.26 material; the same locking problem also
shows up on non-RT kernels.

